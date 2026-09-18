
#include <metal_stdlib>
using namespace metal;
#define HK_NO_STD
#define HK_ADDR thread
#define hk_real float
#define HK_STATIC static inline
#define HK_LIT(x) ((float)(x))
#define HK_PI 3.14159265358979323846f
#define hk_sqrt sqrt
#define hk_sin sin
#define hk_cos cos
#define hk_tan tan
#define hk_atan atan
#define hk_acos acos
#define hk_asin asin
#define hk_exp exp
#define hk_log log
#define hk_fabs fabs
#define hk_floor floor
#define hk_min fmin
#define hk_max fmax
#define hk_eq(a, b) (hk_fabs((a) - (b)) <= 1e-5f * hk_max(1.0f, hk_max(hk_fabs(a), hk_fabs(b))))
