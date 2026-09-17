# Hashemi.lean, compiled

The machine of `~/manifold-pareto/lean/RequestProject/Hashemi.lean` (the master design, 15 sections, 200+
declarations) read as it stands and compiled the way Conal Elliott's *Compiling to categories* compiles Haskell:
one automatic conversion of each definition's `Expr` into a hash-consed dataflow graph (`lean/Ccc.lean`, a MetaM
translator - Lean's reflection is the plugin), and printers off that one graph.

    lake build RequestProject.HashemiCcc        # in ~/manifold-pareto/lean: regenerates everything here

| file | what |
|---|---|
| `hashemi_ccc.h` | C99: every definition as a device function (`hk_*`), the Props as predicates, the closed theorems as checks; MSL/CUDA-neutral through `hk_real`, `HK_LIT`, `HK_ADDR`, `hk_sqrt`... |
| `hashemi_ccc.py` | the same graphs printed for NumPy, vectorised over agents - the env-side reference twin |
| `hashemi_ccc.json` | what compiled, shapes, skip reasons, the parity samples |
| `dot/*.dot` | each definition's dataflow graph (Graphviz) |
| `hashemi_kernel.py` | `hk_step` - `TandoorHashemi.step`, the machine's step - as a Metal kernel (`torch.mps.compile_shader`, one thread per agent) and as CUDA source; `python hashemi_kernel.py` checks Metal against NumPy |
| `test_ccc.py` | parity of the header (compiled in double) against the Lean Float twin, plus the theorem checks in double |
| `lean/` | the compiler and driver, mirrored from the Lean repo: `Ccc.lean` (translator + printers), `HashemiCcc.lean` (driver), `HashemiStep.lean` (the step, composed from the spec) |

Generated in the Lean repo and not mirrored: `HashemiCccRound.lean` - `theorem f_ccc : f = <printed graph> := rfl`
for every compiled definition, Lean's kernel checking that the graph IS the definition (his gold tests, as
theorems) - and `HashemiCccFloat.lean`, the computable twin the parity test runs.

Verification, at the last regeneration: 127 compiled (72 definitions, 7 props, 48 theorem checks; 74 skipped, all
universally-quantified theorems and one higher-order Prop); round trip 0 errors; C vs Float 381/381 samples; 48/48
checks true in double; Metal vs NumPy max relative error 2.6e-6 over 4096 agents.

Vocabulary the translator enforces: real arithmetic, natural-literal powers, `sqrt sin cos tan arctan exp log abs
min max pi`, pairs, `![..]` vectors, structures (unfolded to their fields), `if` on real comparisons, Props from
`< ≤ = ∧ ∨ ¬ ↔` and `∀ i : Fin n`. Anything else is a compile-time error naming the definition. Class methods are
leaves - `Real.add` is never unfolded. `=` on ℝ compiles to a relative tolerance (`hk_eq`, `feq`); everything else
is exact.
