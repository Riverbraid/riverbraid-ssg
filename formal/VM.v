Require Import List Arith.
Import ListNotations.

Inductive Instr :=
| Load (k : nat)
| Store (k : nat)
| Hash
| Halt.

Definition mem_t := list (nat * nat).

Record State := {
  memory : mem_t;
  stack : list nat;
  halted : bool
}.

Fixpoint lookup (k : nat) (m : mem_t) : option nat :=
  match m with
  | [] => None
  | (k', v) :: rest =>
      if Nat.eqb k k' then Some v else lookup k rest
  end.

Definition step (s : State) (i : Instr) : State :=
  if s.(halted) then s else
  match i with
  | Load k =>
      match lookup k s.(memory) with
      | Some v => {| memory := s.(memory); stack := v :: s.(stack); halted := false |}
      | None => s
      end
  | Store k =>
      match s.(stack) with
      | v :: rest => {| memory := (k, v) :: s.(memory); stack := rest; halted := false |}
      | _ => s
      end
  | Hash => s
  | Halt => {| memory := s.(memory); stack := s.(stack); halted := true |}
  end.

Fixpoint run (program : list Instr) (s : State) : State :=
  match program with
  | [] => s
  | i :: rest => if s.(halted) then s else run rest (step s i)
  end.

Require Extraction.
Extraction Language OCaml.

(* Basic Type Mapping *)
Extract Inductive nat => "int" [ "0" "(fun x -> x + 1)" ] 
  "(fun fO fS n -> if n = 0 then fO () else fS (n - 1))".
Extract Inductive bool => "bool" [ "true" "false" ].
Extract Inductive list => "list" [ "[]" "(::)" ].
Extract Inductive option => "option" [ "Some" "None" ].

(* Optimization *)
Extract Inlined Constant Nat.eqb => "(=)".

Extraction "runtime/ssg_vm.ml" run.
