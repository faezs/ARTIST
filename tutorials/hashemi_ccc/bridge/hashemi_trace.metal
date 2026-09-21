
kernel void hashemi_trace(device const float* rays [[buffer(0)]], device const float* prm [[buffer(1)]],
                          device float* out [[buffer(2)]], device const int* n [[buffer(3)]],
                          uint i [[thread_position_in_grid]]) {
  if ((int)i >= n[0]) return;
  const float R = prm[0], f = prm[1], a = prm[2], w = prm[3], rc = prm[4];
  float row[8];
  hk_traceRay(R, f, a, w, rc, rays[i*7+0], rays[i*7+1], rays[i*7+2], rays[i*7+3],
              rays[i*7+4], rays[i*7+5], rays[i*7+6], row);
  for (int k = 0; k < 8; ++k) out[i*8+k] = row[k];
}

kernel void hashemi_trace_err(device const float* rays [[buffer(0)]], device const float* prm [[buffer(1)]],
                              device float* out [[buffer(2)]], device const int* n [[buffer(3)]],
                              uint i [[thread_position_in_grid]]) {
  if ((int)i >= n[0]) return;
  float row[8];
  hk_traceRayErr(prm[0], prm[1], prm[2], prm[3], prm[4], rays[i*11+0], rays[i*11+1], rays[i*11+2], rays[i*11+3],
                 rays[i*11+4], rays[i*11+5], rays[i*11+6], prm[5], prm[6], rays[i*11+7], rays[i*11+8], rays[i*11+9], rays[i*11+10], row);
  for (int k = 0; k < 8; ++k) out[i*8+k] = row[k];
}

kernel void hashemi_trace_k(device const float* rays [[buffer(0)]], device const float* prm [[buffer(1)]],
                            device float* out [[buffer(2)]], device const int* n [[buffer(3)]],
                            uint i [[thread_position_in_grid]]) {
  if ((int)i >= n[0]) return;
  float row[8];
  hk_traceRayK(prm[0], prm[1], prm[2], prm[3], prm[4], prm[5], rays[i*7+0], rays[i*7+1], rays[i*7+2], rays[i*7+3],
               rays[i*7+4], rays[i*7+5], rays[i*7+6], row);
  for (int k = 0; k < 8; ++k) out[i*8+k] = row[k];
}

kernel void hashemi_sphere(device const float* rays [[buffer(0)]], device const float* prm [[buffer(1)]],
                           device float* out [[buffer(2)]], device const int* n [[buffer(3)]],
                           uint i [[thread_position_in_grid]]) {
  if ((int)i >= n[0]) return;
  float row[5];
  hk_traceSphere(prm[0], prm[1], rays[i*6+0], rays[i*6+1], rays[i*6+2], rays[i*6+3], rays[i*6+4], rays[i*6+5], row);
  for (int k = 0; k < 5; ++k) out[i*5+k] = row[k];
}

kernel void hashemi_sun(device const float* pose [[buffer(0)]], device const float* prm [[buffer(1)]],
                        device float* out [[buffer(2)]], device const int* n [[buffer(3)]],
                        uint i [[thread_position_in_grid]]) {
  if ((int)i >= n[0]) return;
  float row[3];
  hk_sunInDish(pose[i*4+0], pose[i*4+1], pose[i*4+2], pose[i*4+3], row);
  out[i*3+0] = row[0]; out[i*3+1] = row[1]; out[i*3+2] = row[2];
}

kernel void hashemi_facet(device const float* rays [[buffer(0)]], device const float* prm [[buffer(1)]],
                          device float* out [[buffer(2)]], device const int* n [[buffer(3)]],
                          uint i [[thread_position_in_grid]]) {
  if ((int)i >= n[0]) return;
  float row[5];
  hk_traceFacet(prm[0], prm[1], rays[i*8+0], rays[i*8+1], rays[i*8+2], rays[i*8+3], rays[i*8+4],
                rays[i*8+5], rays[i*8+6], rays[i*8+7], row);
  for (int k = 0; k < 5; ++k) out[i*5+k] = row[k];
}

kernel void hashemi_conic(device const float* rays [[buffer(0)]], device const float* prm [[buffer(1)]],
                          device float* out [[buffer(2)]], device const int* n [[buffer(3)]],
                          uint i [[thread_position_in_grid]]) {
  if ((int)i >= n[0]) return;
  float row[9];
  hk_traceConic(prm[0], prm[1], prm[2], rays[i*6+0], rays[i*6+1], rays[i*6+2], rays[i*6+3], rays[i*6+4], rays[i*6+5], row);
  for (int k = 0; k < 9; ++k) out[i*9+k] = row[k];
}

kernel void hashemi_dish(device const float* prm [[buffer(0)]], device const float* pose [[buffer(1)]],
                         device const float* dr [[buffer(2)]], device float* out [[buffer(3)]],
                         device const int* n [[buffer(4)]], uint i [[thread_position_in_grid]]) {
  // the env's optics as ONE compiled morphism: prm = R f a w rc k s_slope s_spec rho hsun;
  // pose (B,4) = az t elSun azSun per agent; dr (N,10) = u1..u6 e1 e2 s1 s2 per ray; P rays per agent
  if ((int)i >= n[0]) return;
  const int b = (int)i / n[1];
  float row[5];
  hk_dishPower(prm[0], prm[1], prm[2], prm[3], prm[4], prm[5], prm[6], prm[7], prm[8], prm[9],
               pose[b*4+0], pose[b*4+1], pose[b*4+2], pose[b*4+3],
               dr[i*10+0], dr[i*10+1], dr[i*10+2], dr[i*10+3], dr[i*10+4], dr[i*10+5],
               dr[i*10+6], dr[i*10+7], dr[i*10+8], dr[i*10+9], row);
  for (int k = 0; k < 5; ++k) out[i*5+k] = row[k];
}

kernel void hashemi_sphere_formulas(device const float* rh [[buffer(0)]], device const float* prm [[buffer(1)]],
                                    device float* out [[buffer(2)]], device const int* n [[buffer(3)]],
                                    uint i [[thread_position_in_grid]]) {
  if ((int)i >= n[0]) return;
  const float R = rh[i*3+0], h = rh[i*3+1], p = rh[i*3+2];
  out[i*4+0] = hk_sphereFocal(R, h);
  out[i*4+1] = hk_sphereDev(R, h, p);
  out[i*4+2] = hk_sphereBlur(R, h);
  out[i*4+3] = hk_sphereBestFocus(R, h);
}
