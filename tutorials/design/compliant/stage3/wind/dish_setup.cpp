void main_setup() { // THE FLOWER'S DISH IN THE WIND. A paraboloid bowl (a 2.1 m, f 4.0 m, f/D 0.95) facing the sun at retro, the wind
	// blowing into the bowl, wall-modelled LES (Smagorinsky) on a uniform inflow. Outputs, to DISH_OUT: the force and torque on the
	// bowl every 20 ms (Cd, Cl, Cm and their spectra), the pressure on both faces of the membrane on a polar grid every 0.25 s
	// (the load the film actually feels, front minus back, by azimuthal harmonic), and a mid-plane slice of the velocity at the end.
	// Environment: DISH_DX (m, default 0.06), DISH_U (m/s, 12), DISH_EL (deg, the dish axis' elevation toward -x, 59),
	// DISH_AZ (deg, the axis' azimuth off the wind, 0), DISH_SECONDS (physical seconds after a 3 s settle, 10), DISH_OUT (dir).
	auto envf = [](const char* k, float d) { const char* v = getenv(k); return v ? (float)atof(v) : d; };
	const char* outv = getenv("DISH_OUT"); const string out = outv ? string(outv) : string("/private/tmp/claude-501/-Users-faezs-ARTIST/b026ddf9-1915-4882-a9b5-88b4c0cfa7df/scratchpad/dish_les");
	const float si_dx = envf("DISH_DX", 0.06f), si_U = envf("DISH_U", 12.0f), si_rho = 1.03f, si_nu = 1.5e-5f;
	const float el = envf("DISH_EL", 59.0f)*pif/180.0f, az = envf("DISH_AZ", 0.0f)*pif/180.0f, seconds = envf("DISH_SECONDS", 10.0f);
	const float u_l = 0.10f;
	units.set_m_kg_s(1.0f, u_l, 1.0f, si_dx, si_U, si_rho);
	const float dt_si = si_dx*u_l/si_U;
	const uint Nx = to_uint(24.0f/si_dx)/8u*8u, Ny = to_uint(12.0f/si_dx)/8u*8u, Nz = to_uint(12.0f/si_dx)/8u*8u;
	LBM lbm(Nx, Ny, Nz, units.nu(si_nu));
	const float a = 2.1f/si_dx, fdish = 4.0f/si_dx;
	const float3 n = float3(-cosf(el)*cosf(az), cosf(el)*sinf(az), sinf(el));          // the dish axis, toward the sun (south = -x), the wind blows +x
	const float3 C = float3(0.42f*(float)Nx, 0.5f*(float)Ny, 0.55f*(float)Nz);          // the vertex
	float3 e1 = normalize(cross(n, float3(0.0f, 1.0f, 0.0f))); const float3 e2 = normalize(cross(n, e1));
	const float shell = 1.2f;
	parallel_for(lbm.get_N(), [&](ulong i) { uint x=0u, y=0u, z=0u; lbm.coordinates(i, x, y, z);
		const float3 p = float3((float)x, (float)y, (float)z) - C;
		const float xi = dot(p, e1), eta = dot(p, e2), zeta = dot(p, n);
		const float rr = sqrtf(xi*xi + eta*eta), zs = rr*rr/(4.0f*fdish);
		if(rr <= a && fabsf(zeta - zs) <= shell) { lbm.flags[i] = TYPE_S|TYPE_X; }
		else {
			if(x==0u||x==Nx-1u||y==0u||y==Ny-1u||z==0u||z==Nz-1u) lbm.flags[i] = TYPE_E;
			lbm.u.x[i] = u_l;
		}
	});
	// probes on both faces of the membrane: 24 rings x 48 azimuths, 3 cells off the surface along the axis
	const uint NR = 24u, NT = 48u; std::vector<ulong> pf, pb; std::vector<float> prho, pth;
	for(uint ir=0u; ir<NR; ir++) for(uint it=0u; it<NT; it++) {
		const float rr = (0.06f + 0.92f*((float)ir + 0.5f)/(float)NR)*a, th = 2.0f*pif*(float)it/(float)NT;
		const float xi = rr*cosf(th), eta = rr*sinf(th), zs = rr*rr/(4.0f*fdish);
		const float3 Xf = C + xi*e1 + eta*e2 + (zs + 3.0f)*n, Xb = C + xi*e1 + eta*e2 + (zs - 3.0f)*n;
		pf.push_back(lbm.index(to_uint(Xf.x + 0.5f), to_uint(Xf.y + 0.5f), to_uint(Xf.z + 0.5f)));
		pb.push_back(lbm.index(to_uint(Xb.x + 0.5f), to_uint(Xb.y + 0.5f), to_uint(Xb.z + 0.5f)));
		prho.push_back(rr/a); pth.push_back(th);
	}
	const float q_si = 0.5f*si_rho*si_U*si_U, A_si = pif*2.1f*2.1f;
	const ulong settle = (ulong)(3.0f/dt_si), total = (ulong)((3.0f + seconds)/dt_si), every_f = 20ull, every_p = (ulong)(0.25f/dt_si);
	print_info("dish LES: "+to_string(Nx)+"x"+to_string(Ny)+"x"+to_string(Nz)+" cells, dx "+to_string(si_dx, 3u)+" m, dt "+to_string(1e3f*dt_si, 3u)+" ms, "+to_string(total)+" steps, el "+to_string(el*180.0f/pif, 1u)+" deg, U "+to_string(si_U, 1u)+" m/s");
	std::ofstream ff(out + "/forces.csv"), fp(out + "/pressure.csv");
	ff << "t_s,Fx_N,Fy_N,Fz_N,Mx_Nm,My_Nm,Mz_Nm,Cd,Cl,Cm\n";
	fp << "t_s"; for(uint k=0u; k<pf.size(); k++) fp << ",f" << k; for(uint k=0u; k<pb.size(); k++) fp << ",b" << k; fp << "\n";
	{ std::ofstream fg(out + "/probes.csv"); fg << "k,rho_over_a,theta\n"; for(uint k=0u; k<pf.size(); k++) fg << k << "," << prho[k] << "," << pth[k] << "\n"; }
	lbm.run(0u); // initialise
	while(lbm.get_t() < total) {
		lbm.run(every_f);
		const ulong t = lbm.get_t();
		if(t >= settle) {
			const float3 Cc = float3(C.x - 0.5f*(float)Nx + 0.5f, C.y - 0.5f*(float)Ny + 0.5f, C.z - 0.5f*(float)Nz + 0.5f); // the torque kernel works in box-centred coordinates (lbm.position)
			const float3 F = lbm.object_force(TYPE_S|TYPE_X), M = lbm.object_torque(Cc, TYPE_S|TYPE_X);
			const float sF = units.si_F(1.0f), sM = units.si_F(1.0f)*si_dx;
			const float Fx = F.x*sF, Fy = F.y*sF, Fz = F.z*sF;
			const float Fn = Fx*n.x + Fy*n.y + Fz*n.z;                                          // along the dish axis
			ff << (float)t*dt_si << "," << Fx << "," << Fy << "," << Fz << "," << M.x*sM << "," << M.y*sM << "," << M.z*sM
			   << "," << Fx/(q_si*A_si) << "," << Fz/(q_si*A_si) << "," << M.y*sM/(q_si*A_si*4.2f) << "\n";
			if(t % every_p < every_f) {
				lbm.rho.read_from_device();
				fp << (float)t*dt_si;
				for(uint k=0u; k<pf.size(); k++) fp << "," << (lbm.rho[pf[k]] - 1.0f)/3.0f*units.si_p(1.0f)/q_si;
				for(uint k=0u; k<pb.size(); k++) fp << "," << (lbm.rho[pb[k]] - 1.0f)/3.0f*units.si_p(1.0f)/q_si;
				fp << "\n"; fp.flush(); ff.flush();
				print_info("t "+to_string((float)t*dt_si, 2u)+" s  Cd "+to_string(Fx/(q_si*A_si), 3u)+"  Cl "+to_string(Fz/(q_si*A_si), 3u)+"  Cm "+to_string(M.y*sM/(q_si*A_si*4.2f), 3u));
			}
		}
	}
	// the mid-plane slice of velocity (y = Ny/2): Nx x Nz x 3 floats, and the flags on that plane
	lbm.u.read_from_device(); lbm.flags.read_from_device();
	std::ofstream fs(out + "/slice_u.bin", std::ios::binary); const uint yy = Ny/2u;
	fs.write((const char*)&Nx, 4); fs.write((const char*)&Nz, 4);
	for(uint z=0u; z<Nz; z++) for(uint x=0u; x<Nx; x++) { const ulong i = lbm.index(x, yy, z);
		const float v[4] = { lbm.u.x[i]*units.si_u(1.0f), lbm.u.y[i]*units.si_u(1.0f), lbm.u.z[i]*units.si_u(1.0f), (float)(lbm.flags[i]&TYPE_S) };
		fs.write((const char*)v, 16); }
	print_info("done: "+out);
}
