/* metal_bridge.m - Lean calls Metal.
   One C function, `lean_mtl_run`: JIT-compile an MSL source (cached by kernel name and source hash,
   the same `newLibraryWithSource` that torch.mps.compile_shader uses), bind the buffers Lean hands
   over as FloatArrays (converted to float32 or int32 for the GPU, per `kinds`), dispatch `grid`
   threads, wait, and return every buffer's contents as FloatArrays. Any kernel of the project - the
   handwritten tandoor_trace, the generated hashemi_mega, his dish's trace - is callable from Lean
   through it, so a theorem's evidence can be a trace.
   Build: ./build.sh (clang, -framework Metal -framework Foundation, the Lean runtime resolved at load). */
#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#include <lean/lean.h>
#include <math.h>
#include <string.h>

static id<MTLDevice> g_dev = nil;
static id<MTLCommandQueue> g_q = nil;
static NSMutableDictionary<NSString *, id<MTLComputePipelineState>> *g_pso = nil;

static lean_obj_res io_err(NSString *msg) {
    return lean_io_result_mk_error(lean_mk_io_user_error(lean_mk_string([msg UTF8String])));
}

static id<MTLComputePipelineState> pipeline(NSString *src, NSString *kernel, NSString **why) {
    if (!g_dev) {
        g_dev = MTLCreateSystemDefaultDevice();
        if (!g_dev) { *why = @"no Metal device"; return nil; }
        g_q = [g_dev newCommandQueue];
        g_pso = [NSMutableDictionary new];
    }
    NSString *key = [NSString stringWithFormat:@"%@#%lu", kernel, (unsigned long)[src hash]];
    id<MTLComputePipelineState> p = g_pso[key];
    if (p) return p;
    NSError *err = nil;
    MTLCompileOptions *opts = [MTLCompileOptions new];
    id<MTLLibrary> lib = [g_dev newLibraryWithSource:src options:opts error:&err];
    if (!lib) { *why = [NSString stringWithFormat:@"compile: %@", err.localizedDescription]; return nil; }
    id<MTLFunction> fn = [lib newFunctionWithName:kernel];
    if (!fn) { *why = [NSString stringWithFormat:@"no kernel %@ in the source", kernel]; return nil; }
    p = [g_dev newComputePipelineStateWithFunction:fn error:&err];
    if (!p) { *why = [NSString stringWithFormat:@"pipeline: %@", err.localizedDescription]; return nil; }
    g_pso[key] = p;
    return p;
}

/* Lean: @[extern "lean_mtl_run"] opaque run (src kernel : @& String) (bufs : @& Array FloatArray)
   (kinds : @& Array Nat) (grid tg : USize) : IO (Array FloatArray)
   kinds: 0 = float32, 1 = int32 (values rounded), buffers bound at index = position. */
LEAN_EXPORT lean_obj_res lean_mtl_run(b_lean_obj_arg src, b_lean_obj_arg kernel, b_lean_obj_arg bufs,
                                      b_lean_obj_arg kinds, size_t grid, size_t tg, lean_obj_arg w) {
    @autoreleasepool {
        NSString *why = nil;
        NSString *s = [NSString stringWithUTF8String:lean_string_cstr(src)];
        NSString *k = [NSString stringWithUTF8String:lean_string_cstr(kernel)];
        id<MTLComputePipelineState> pso = pipeline(s, k, &why);
        if (!pso) return io_err([NSString stringWithFormat:@"metal_bridge: %@", why]);
        size_t nb = lean_array_size(bufs);
        if (lean_array_size(kinds) != nb) return io_err(@"metal_bridge: kinds and buffers differ in length");
        NSMutableArray<id<MTLBuffer>> *mb = [NSMutableArray arrayWithCapacity:nb];
        for (size_t i = 0; i < nb; ++i) {
            lean_object *fa = lean_array_get_core(bufs, i);
            size_t n = lean_sarray_size(fa);
            const double *d = lean_float_array_cptr(fa);
            size_t kind = lean_unbox(lean_array_get_core(kinds, i));
            id<MTLBuffer> b = [g_dev newBufferWithLength:(n ? n * 4 : 4) options:MTLResourceStorageModeShared];
            if (kind == 1) {
                int32_t *p = (int32_t *)b.contents;
                for (size_t j = 0; j < n; ++j) p[j] = (int32_t)llround(d[j]);
            } else {
                float *p = (float *)b.contents;
                for (size_t j = 0; j < n; ++j) p[j] = (float)d[j];
            }
            [mb addObject:b];
        }
        id<MTLCommandBuffer> cmd = [g_q commandBuffer];
        id<MTLComputeCommandEncoder> enc = [cmd computeCommandEncoder];
        [enc setComputePipelineState:pso];
        for (size_t i = 0; i < nb; ++i) [enc setBuffer:mb[i] offset:0 atIndex:i];
        NSUInteger maxTg = pso.maxTotalThreadsPerThreadgroup;
        NSUInteger tgs = tg ? MIN((NSUInteger)tg, maxTg) : MIN((NSUInteger)256, maxTg);
        if (grid == 0) grid = 1;
        [enc dispatchThreads:MTLSizeMake(grid, 1, 1) threadsPerThreadgroup:MTLSizeMake(tgs, 1, 1)];
        [enc endEncoding];
        [cmd commit];
        [cmd waitUntilCompleted];
        if (cmd.error) return io_err([NSString stringWithFormat:@"metal_bridge: run: %@", cmd.error.localizedDescription]);
        lean_object *out = lean_alloc_array(nb, nb);
        for (size_t i = 0; i < nb; ++i) {
            lean_object *fa = lean_array_get_core(bufs, i);
            size_t n = lean_sarray_size(fa);
            size_t kind = lean_unbox(lean_array_get_core(kinds, i));
            lean_object *r = lean_alloc_sarray(sizeof(double), n, n);
            double *rd = lean_float_array_cptr(r);
            if (kind == 1) { const int32_t *p = (const int32_t *)mb[i].contents; for (size_t j = 0; j < n; ++j) rd[j] = (double)p[j]; }
            else { const float *p = (const float *)mb[i].contents; for (size_t j = 0; j < n; ++j) rd[j] = (double)p[j]; }
            lean_array_set_core(out, i, r);
        }
        return lean_io_result_mk_ok(out);
    }
}
