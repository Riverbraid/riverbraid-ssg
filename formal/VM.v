Require Import List Arith.
Import ListNotations.

Inductive Instr :=
| Load (k : nat)
| Store (k : nat)
| Push (v : nat)
| Hash
| Halt.

Definition mem_t := list (nat * nat).

Record State := mkState {
  memory : mem_t;
  stack : list nat;
  halted : bool
}.

Fixpoint lookup (k : nat) (m : mem_t) : option nat :=
  match m with
  | [] => None
  | (k', v) :: rest => if Nat.eqb k k' then Some v else lookup k rest
  end.

Definition store (k v : nat) (m : mem_t) : mem_t := (k, v) :: m.

Definition step (s : State) (i : Instr) : State :=
  if s.(halted) then s else
  match i with
  | Load k => match lookup k s.(memory) with
              | Some v => mkState s.(memory) (v :: s.(stack)) false
              | None   => s
              end
  | Store k => match s.(stack) with
               | v :: rest => mkState (store k v s.(memory)) rest false
               | [] => s
               end
  | Push v => mkState s.(memory) (v :: s.(stack)) false
  | Hash => s
  | Halt => mkState s.(memory) s.(stack) true
  end.

Fixpoint run (s : State) (prog : list Instr) : State :=
  match prog with
  | [] => s
  | i :: rest => run (step s i) rest
  end.
