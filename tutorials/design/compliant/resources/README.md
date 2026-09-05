# Third-party resources (not committed)

Downloaded 2026-09-04 at the user's request; the authors' copyright,
no licence stated, so the files stay untracked (`../.gitignore`).

| file | source | size | what |
|---|---|---|---|
| `dcm_supplementary_software.zip` -> `dcm_supplementary_software/` | https://github.com/jonathanbhopkins/Computationally-Efficient-Design-of-Directionally-Compliant-Metamaterials (raw `Supplementary Software.zip`, master) | 725 KB | Shaw et al. 2019 DCM design tool: `MaterialDesignGUI.m` (the design functions), `MaterialDesignGUI.fig`, `images.mat`; the UCLA software page's "Software Tool for Designing Directionally Compliant Metamaterials" points at the same three files |
| `dcm_repo_README.md` | same repository | 1 KB | the repository's README |
| `hopkins_2010_FACT_thesis.pdf` | https://dspace.mit.edu/handle/1721.1/62511 (fetched 2026-09-05 at the user's request) | 38.9 MB, 195 pp. | Hopkins, Design of flexure-based motion stages via Freedom, Actuation and Constraint Topologies, MIT PhD 2010: the FACT chart (50 types), the design process (Fig. 2.7), serial synthesis, actuation spaces and the twist-wrench stiffness matrix (ch. 4), Appendix B actuation-space code |
| `fact_matlab_tool.zip` -> `fact_matlab_tool/` | https://flexible.seas.ucla.edu/software, "MATLAB TOOL-Final.zip" | 4.96 MB | NOT the FACT/DCM code: the sequential-metamaterial (alternating Poisson's ratio) GUI of Farzaneh et al. 2022 (`Metamaterial.m`, `Metamaterial_results.m`, `data.mat`, `Readme.pdf`; also at github.com/aminfno/Metamaterial) |

The other archive on the UCLA page ("Designing Compliant-mechanism
Mattress Panels.zip", Yang et al. 2025) was not downloaded. The FACT
synthesis itself has no separate download on that page; its algebra
is in Hopkins's papers and our port `../fact/fact_core.py` /
`../fact/dcm_core.py`.

## Added 2026-09-06 (setup simulation)

- `blumenschein_2019_soft_growing_robots_thesis.pdf`: L. H. Blumenschein, *Design and modeling of soft growing robots*, Stanford 2019 (stacks.stanford.edu, druid nm099kn3764). Ch. 2 growth force P A and the Lockhart-Ortega turgor law; ch. 4 actuator routing.
- `coad_2021_vine_robots_thesis.pdf`: M. M. Coad, *Design, modeling, and control of vine robots for exploration of unknown environments*, Stanford 2021 (druid ky237km2272). 4.3.2-4.3.3 inflated-beam axial buckling and crushing, curved-beam bending.
- `vine_collapse_own_weight_2025.pdf`: McFarland and McGuinness, *Modeling collapse of steered vine robots under their own weight*, arXiv 2510.25727. Collapse moment P pi D^3/8, tail tension, inflated supports.
- `vine_steerability_2025.pdf` (arXiv 2510.22504), `vine_parallel_sim_2025.pdf` (Gao, Chen, Bhovad, Wang, Kingston, Blumenschein, arXiv 2509.15180: fast parallel simulation of growth, bending, actuation and contact).
- `vine_simulator_icra.pdf` and `Vine_Simulator/` (git clone of charm-lab/Vine_Simulator, Julia): Jitosho, Agharese, Okamura, Manchester, a rigid-link dynamics simulator for vine robots with growth as a rate constraint.
- `bruder_2019_koopman_mpc_soft_robots.pdf`: Bruder, Gillespie, Remy, Vasudevan, *Modeling and control of soft robots using the Koopman operator and model predictive control*, RSS 2019 (arXiv 1902.02827). Software: `pykoopman` (installed in `.venv-sim`), `pyelastica` (installed, unused so far).
- The simulation venv is `.venv-sim/` (uv; warp-lang 1.8.1 for warp.sim's ModelBuilder API and the kernels, pykoopman, pyelastica, numpy, scipy, imageio, matplotlib). Not tracked.
