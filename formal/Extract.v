Require Extraction.
Require Import VM.
Require Import Run.
Extraction Language OCaml.
Extract Inductive nat => "int" [ "0" "(fun x -> x + 1)" ] "(fun fO fS n -> if n = 0 then fO () else fS (n-1))".
Extraction "ssg_vm.ml" Instr State step run lookup store initial_state example_program.
