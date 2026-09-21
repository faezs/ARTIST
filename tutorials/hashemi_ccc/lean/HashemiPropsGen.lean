/-
`lake build RequestProject.HashemiPropsGen` writes HashemiProps.lean: the design's theorems
(Hashemi.lean) as predicates, each proved by its theorem. See PropsGenCore.lean.
-/
import RequestProject.Hashemi
import RequestProject.PropsGenCore

#eval HashemiPropsGen.run `RequestProject.Hashemi [`RequestProject.Hashemi] "RequestProject.Hashemi" "HashemiProps.lean"
