Require Import VM List.
Definition initial_state : State := mkState nil nil false.
Definition example_program : list Instr := (Push 42) :: (Store 0) :: (Load 0) :: (Halt) :: nil.
