// Minimal three.js (r128, cdnjs) viewer for the mesh JSON: shaded parts, hemisphere + key light, own orbit control.
// usage: mountViewer(document.getElementById('view1'), MODEL_JSON_OBJECT, {up:'z', units:'mm'})
function mountViewer(el, model, opt) {
  opt = opt || {};
  const W = el.clientWidth || 800, H = el.clientHeight || 520;
  const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2)); renderer.setSize(W, H); el.appendChild(renderer.domElement);
  const scene = new THREE.Scene();
  const group = new THREE.Group(); if ((opt.up || 'z') === 'z') group.rotation.x = -Math.PI / 2; scene.add(group);
  let minB = new THREE.Vector3(Infinity, Infinity, Infinity), maxB = new THREE.Vector3(-Infinity, -Infinity, -Infinity);
  model.parts.forEach(p => {
    if (p.lines) {                       // line-segment parts (lattice wires, axes): cheap to ship and draw
      const pos = new Float32Array(p.lines.length * 6);
      p.lines.forEach((s, i) => { pos.set([s[0][0], s[0][1], s[0][2], s[1][0], s[1][1], s[1][2]], 6 * i); });
      const lg = new THREE.BufferGeometry(); lg.setAttribute('position', new THREE.BufferAttribute(pos, 3)); lg.computeBoundingBox();
      minB.min(lg.boundingBox.min); maxB.max(lg.boundingBox.max);
      const ls = new THREE.LineSegments(lg, new THREE.LineBasicMaterial({ color: new THREE.Color(p.color) })); ls.name = p.name; group.add(ls); return;
    }
    const g = new THREE.BufferGeometry(); const pos = new Float32Array(p.v.length * 3);
    p.v.forEach((v, i) => { pos[3 * i] = v[0]; pos[3 * i + 1] = v[1]; pos[3 * i + 2] = v[2]; });
    g.setAttribute('position', new THREE.BufferAttribute(pos, 3)); g.setIndex(p.f.flat()); g.computeVertexNormals(); g.computeBoundingBox();
    minB.min(g.boundingBox.min); maxB.max(g.boundingBox.max);
    const m = new THREE.MeshStandardMaterial({ color: new THREE.Color(p.color), metalness: 0.15, roughness: 0.55, side: THREE.DoubleSide });
    const mesh = new THREE.Mesh(g, m); mesh.name = p.name; group.add(mesh);
    const edges = new THREE.LineSegments(new THREE.EdgesGeometry(g, 25), new THREE.LineBasicMaterial({ color: 0x14213d, transparent: true, opacity: 0.35 })); group.add(edges);
  });
  const c = minB.clone().add(maxB).multiplyScalar(0.5), R = maxB.clone().sub(minB).length() * 0.5 || 100;
  group.position.set(-c.x, -c.z, c.y); // recentre after the z-up rotation
  scene.add(new THREE.HemisphereLight(0xffffff, 0x8899aa, 0.9));
  const key = new THREE.DirectionalLight(0xffffff, 0.8); key.position.set(1, 2, 1.5); scene.add(key);
  const cam = new THREE.PerspectiveCamera(35, W / H, R / 100, R * 20);
  let theta = 0.8, phi = 1.05, dist = R * 3.2, tx = 0, ty = 0;
  function place() { cam.position.set(dist * Math.sin(phi) * Math.cos(theta) + tx, dist * Math.cos(phi) + ty, dist * Math.sin(phi) * Math.sin(theta)); cam.lookAt(tx, ty, 0); renderer.render(scene, cam); }
  let drag = null; const dom = renderer.domElement; dom.style.cursor = 'grab';
  dom.addEventListener('pointerdown', e => { drag = { x: e.clientX, y: e.clientY, b: e.button, sh: e.shiftKey }; dom.setPointerCapture(e.pointerId); });
  dom.addEventListener('pointerup', () => drag = null);
  dom.addEventListener('pointermove', e => { if (!drag) return; const dx = e.clientX - drag.x, dy = e.clientY - drag.y; drag.x = e.clientX; drag.y = e.clientY;
    if (drag.b === 2 || drag.sh) { tx -= dx * dist / 800; ty += dy * dist / 800; } else { theta += dx * 0.01; phi = Math.min(Math.max(phi - dy * 0.01, 0.05), Math.PI - 0.05); } place(); });
  dom.addEventListener('wheel', e => { e.preventDefault(); dist *= Math.exp(e.deltaY * 0.001); dist = Math.min(Math.max(dist, R * 0.4), R * 12); place(); }, { passive: false });
  dom.addEventListener('contextmenu', e => e.preventDefault());
  window.addEventListener('resize', () => { const w = el.clientWidth; renderer.setSize(w, H); cam.aspect = w / H; cam.updateProjectionMatrix(); place(); });
  place(); return { scene, cam, renderer, place };
}
