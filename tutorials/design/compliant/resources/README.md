# Third-party resources (not committed)

Downloaded 2026-09-04 at the user's request; the authors' copyright,
no licence stated, so the files stay untracked (`../.gitignore`).

| file | source | size | what |
|---|---|---|---|
| `dcm_supplementary_software.zip` -> `dcm_supplementary_software/` | https://github.com/jonathanbhopkins/Computationally-Efficient-Design-of-Directionally-Compliant-Metamaterials (raw `Supplementary Software.zip`, master) | 725 KB | Shaw et al. 2019 DCM design tool: `MaterialDesignGUI.m` (the design functions), `MaterialDesignGUI.fig`, `images.mat`; the UCLA software page's "Software Tool for Designing Directionally Compliant Metamaterials" points at the same three files |
| `dcm_repo_README.md` | same repository | 1 KB | the repository's README |
| `fact_matlab_tool.zip` -> `fact_matlab_tool/` | https://flexible.seas.ucla.edu/software, "MATLAB TOOL-Final.zip" | 4.96 MB | NOT the FACT/DCM code: the sequential-metamaterial (alternating Poisson's ratio) GUI of Farzaneh et al. 2022 (`Metamaterial.m`, `Metamaterial_results.m`, `data.mat`, `Readme.pdf`; also at github.com/aminfno/Metamaterial) |

The other archive on the UCLA page ("Designing Compliant-mechanism
Mattress Panels.zip", Yang et al. 2025) was not downloaded. The FACT
synthesis itself has no separate download on that page; its algebra
is in Hopkins's papers and our port `../fact/fact_core.py` /
`../fact/dcm_core.py`.
