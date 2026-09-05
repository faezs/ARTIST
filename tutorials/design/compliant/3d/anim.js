// three.js (r128) player for the self-setup simulation frames: setup_sim.py's JSON (int16 centimetre positions per frame, zlib+base64).
// usage: mountAnim(document.getElementById('anim1'), ANIM_JSON_OBJECT)
async function mountAnim(el, anim) {
  const W = el.clientWidth || 800, H = el.clientHeight || 520;
  const bytes = Uint8Array.from(atob(anim.blob), c => c.charCodeAt(0));
  let Q;
  try { const buf = await new Response(new Blob([bytes]).stream().pipeThrough(new DecompressionStream('deflate'))).arrayBuffer(); Q = new Int16Array(buf); }
  catch (e) { el.textContent = 'This browser cannot inflate the frames (DecompressionStream missing): ' + e; return; }
  const nf = anim.n_frames, np = anim.n_particles, sc = anim.scale;
  const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2)); renderer.setSize(W, H); el.appendChild(renderer.domElement);
  const scene = new THREE.Scene(); const group = new THREE.Group(); group.rotation.x = -Math.PI / 2; scene.add(group);
  // deck, rail
  const deck = new THREE.Mesh(new THREE.PlaneGeometry(16, 16), new THREE.MeshStandardMaterial({ color: 0xdfe3e8, roughness: 0.9, side: THREE.DoubleSide })); deck.position.set(3.0, 0, -0.005); group.add(deck);
  const grid = new THREE.GridHelper(16, 16, 0xb0b8c4, 0xd0d6de); grid.rotation.x = Math.PI / 2; grid.position.set(3.0, 0, 0.002); group.add(grid);
  if (anim.rail) { const rail = new THREE.Mesh(new THREE.TorusGeometry(anim.rail.r, 0.06, 10, 64), new THREE.MeshStandardMaterial({ color: 0x9aa5b1 })); rail.position.set(anim.rail.c[0], anim.rail.c[1], 0.06); group.add(rail); }
  // tubes: one membrane mesh over all particles, indexed by the tube triangles
  const pos = new Float32Array(np * 3); const g = new THREE.BufferGeometry(); g.setAttribute('position', new THREE.BufferAttribute(pos, 3)); g.setIndex(anim.tris);
  const tube = new THREE.Mesh(g, new THREE.MeshStandardMaterial({ color: 0x7fb3e6, metalness: 0.05, roughness: 0.5, side: THREE.DoubleSide, transparent: true, opacity: 0.9 })); group.add(tube);
  function lines(pairs, color) { const arr = new Float32Array(pairs.length * 6); const lg = new THREE.BufferGeometry(); lg.setAttribute('position', new THREE.BufferAttribute(arr, 3)); const ls = new THREE.LineSegments(lg, new THREE.LineBasicMaterial({ color })); group.add(ls); return { pairs, arr, lg }; }
  const rimPairs = anim.rim.map((r, i) => [r, anim.rim[(i + 1) % anim.rim.length]]).concat(anim.frame.map((r, i) => [r, anim.frame[(i + 1) % anim.frame.length]]));
  const L_head = lines(anim.head_lines, 0x334155), L_rim = lines(rimPairs, 0xd69e2e), L_axle = lines(anim.axle_lines || [], 0xdd6b20), L_mus = lines(anim.muscles || [], 0xb91c1c), L_wire = lines(anim.wires || [], 0x2563eb), L_rod = lines(anim.fine_rods || [], 0x15803d), L_col = lines(anim.fine_cols || [], 0xb45309);
  const fanIdx = []; anim.rim.forEach((r, i) => fanIdx.push(anim.vtx, r, anim.rim[(i + 1) % anim.rim.length]));
  const fan = new THREE.Mesh(new THREE.BufferGeometry(), new THREE.MeshStandardMaterial({ color: 0xf6e05e, side: THREE.DoubleSide, transparent: true, opacity: 0.6 }));
  fan.geometry.setAttribute('position', new THREE.BufferAttribute(pos, 3)); fan.geometry.setIndex(fanIdx); group.add(fan);
  const Fs = new THREE.Mesh(new THREE.SphereGeometry(0.12, 16, 12), new THREE.MeshStandardMaterial({ color: 0x7c3aed })); group.add(Fs);
  const tgtM = new THREE.Mesh(new THREE.TorusGeometry(0.35, 0.03, 8, 32), new THREE.MeshStandardMaterial({ color: 0xd9480f })); group.add(tgtM);
  const tanks = (anim.tanks || []).map(() => { const m = new THREE.Mesh(new THREE.SphereGeometry(0.28, 14, 10), new THREE.MeshStandardMaterial({ color: 0x2b6cb0, transparent: true, opacity: 0.8 })); group.add(m); return m; });
  const sunL = new THREE.Line(new THREE.BufferGeometry().setFromPoints([new THREE.Vector3(), new THREE.Vector3()]), new THREE.LineDashedMaterial({ color: 0x0e7490, dashSize: 0.3, gapSize: 0.15 })); group.add(sunL);
  scene.add(new THREE.HemisphereLight(0xffffff, 0x8899aa, 0.9)); const key = new THREE.DirectionalLight(0xffffff, 0.8); key.position.set(1, 2, 1.5); scene.add(key);
  const cx = 1.5, cy = 0, cz = 4.0; group.position.set(-cx, -cz, cy);
  const cam = new THREE.PerspectiveCamera(35, W / H, 0.1, 200); let theta = -0.7, phi = 1.2, dist = 22, tx = 0, ty = 0;
  function place() { cam.position.set(dist * Math.sin(phi) * Math.cos(theta) + tx, dist * Math.cos(phi) + ty, dist * Math.sin(phi) * Math.sin(theta)); cam.lookAt(tx, ty, 0); renderer.render(scene, cam); }
  function P(fr, i, k) { return Q[(fr * np + i) * 3 + k] * sc; }
  function setFrame(fr) {
    for (let i = 0; i < np; i++) { pos[3 * i] = P(fr, i, 0); pos[3 * i + 1] = P(fr, i, 1); pos[3 * i + 2] = P(fr, i, 2); }
    g.attributes.position.needsUpdate = true; g.computeVertexNormals(); fan.geometry.attributes.position.needsUpdate = true; fan.geometry.computeVertexNormals();
    [L_head, L_rim, L_axle, L_mus, L_wire, L_rod, L_col].forEach(L => { L.pairs.forEach((pr, e) => { for (let s = 0; s < 2; s++) { const i = pr[s]; L.arr[6 * e + 3 * s] = pos[3 * i]; L.arr[6 * e + 3 * s + 1] = pos[3 * i + 1]; L.arr[6 * e + 3 * s + 2] = pos[3 * i + 2]; } }); L.lg.attributes.position.needsUpdate = true; });
    const lg = anim.log[fr]; Fs.position.set(pos[3 * anim.F], pos[3 * anim.F + 1], pos[3 * anim.F + 2]);
    (anim.tanks || []).forEach((ti, k) => { tanks[k].position.set(pos[3 * ti], pos[3 * ti + 1], pos[3 * ti + 2]); const s = lg ? Math.cbrt(Math.max(lg.tank, 1) / 91) : 1; tanks[k].scale.set(s, s, s); });
    if (lg) { tgtM.position.set(lg.tgt[0], lg.tgt[1], lg.tgt[2]); const d = new THREE.Vector3(Fs.position.x - lg.tgt[0], Fs.position.y - lg.tgt[1], Fs.position.z - lg.tgt[2]).normalize(); tgtM.lookAt(tgtM.position.clone().add(d));
      const vx = new THREE.Vector3(pos[3 * anim.vtx], pos[3 * anim.vtx + 1], pos[3 * anim.vtx + 2]); sunL.geometry.setFromPoints([vx.clone().add(d.clone().multiplyScalar(2.5)), vx.clone().add(d.clone().multiplyScalar(7))]); sunL.computeLineDistances();
      const T = anim.t_setup, ph = lg.t < 0.08 * T ? 'stowed, tubes pressurised' : lg.t < 0.42 * T ? 'posts grow to the height of F' : lg.t < 0.66 * T ? 'arms and counterweight tubes grow' : lg.t < 0.74 * T ? 'water pumped into the counterweights' : lg.t < T ? 'muscles turn the cradle to the morning sun' : 'tracking the sun';
      label.textContent = `t ${lg.t.toFixed(1)} s · ${ph} · sun ${lg.hour.toFixed(1)} h · axis z ${(lg.z_axis + anim.z_offset).toFixed(2)} m (F ${(4.868 + anim.z_offset).toFixed(2)}) · vertex error ${lg.err.toFixed(2)} m · coarse ${(lg.coarse !== undefined ? lg.coarse : lg.point).toFixed(1)}° · dish ${lg.point < 0.1 ? (lg.point * 17.45).toFixed(2) + ' mrad' : lg.point.toFixed(2) + '°'} · struts ${Math.max.apply(null, lg.muscles).toFixed(0)} N`; }
    place();
  }
  const bar = document.createElement('div'); bar.style.cssText = 'display:flex;gap:8px;align-items:center;padding:6px 8px;font:12px "IBM Plex Mono",monospace;color:#14213d;background:#fff;border-top:1px solid #c7d0da';
  const btn = document.createElement('button'); btn.textContent = 'pause'; btn.style.cssText = 'font:inherit;padding:2px 8px'; const rng = document.createElement('input'); rng.type = 'range'; rng.min = 0; rng.max = nf - 1; rng.value = 0; rng.style.flex = '1';
  const label = document.createElement('span'); label.style.cssText = 'white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:62%'; bar.append(btn, rng, label); el.appendChild(bar);
  let fr = 0, playing = true, last = 0; const step_ms = anim.dt * 1000;
  btn.onclick = () => { playing = !playing; btn.textContent = playing ? 'pause' : 'play'; if (playing) requestAnimationFrame(tick); };
  rng.oninput = () => { fr = +rng.value; setFrame(fr); };
  function tick(ts) { if (!playing) return; if (ts - last >= step_ms) { last = ts; fr = (fr + 1) % nf; rng.value = fr; setFrame(fr); } requestAnimationFrame(tick); }
  let drag = null; const dom = renderer.domElement; dom.style.cursor = 'grab';
  dom.addEventListener('pointerdown', e => { drag = { x: e.clientX, y: e.clientY, b: e.button, sh: e.shiftKey }; dom.setPointerCapture(e.pointerId); });
  dom.addEventListener('pointerup', () => drag = null);
  dom.addEventListener('pointermove', e => { if (!drag) return; const dx = e.clientX - drag.x, dy = e.clientY - drag.y; drag.x = e.clientX; drag.y = e.clientY;
    if (drag.b === 2 || drag.sh) { tx -= dx * dist / 800; ty += dy * dist / 800; } else { theta += dx * 0.01; phi = Math.min(Math.max(phi - dy * 0.01, 0.05), Math.PI - 0.05); } place(); });
  dom.addEventListener('wheel', e => { e.preventDefault(); dist *= Math.exp(e.deltaY * 0.001); dist = Math.min(Math.max(dist, 4), 80); place(); }, { passive: false });
  dom.addEventListener('contextmenu', e => e.preventDefault());
  window.addEventListener('resize', () => { const w = el.clientWidth; renderer.setSize(w, H); cam.aspect = w / H; cam.updateProjectionMatrix(); place(); });
  setFrame(0); requestAnimationFrame(tick);
}
