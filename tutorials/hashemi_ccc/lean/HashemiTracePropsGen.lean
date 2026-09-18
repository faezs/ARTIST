/-
`lake build RequestProject.HashemiTracePropsGen` writes HashemiTraceProps.lean: the trace's
theorems (HashemiTrace.lean) as predicates, each proved by its theorem. See PropsGenCore.lean.
-/
import RequestProject.HashemiTrace
import RequestProject.PropsGenCore

#eval HashemiPropsGen.run `RequestProject.HashemiTrace
  [`RequestProject.Hashemi, `RequestProject.HashemiStep, `RequestProject.HashemiMega, `RequestProject.HashemiTrace]
  "RequestProject.HashemiTrace" "HashemiTraceProps.lean"
  [`TandoorHashemi.dishPower_captured, `TandoorHashemi.dishPower_le]
