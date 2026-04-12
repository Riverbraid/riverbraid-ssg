open Ssg_vm

let () =
  if Array.length Sys.argv < 2 then (
    print_endline "Usage: riverbraid_vm <program.ir>";
    exit 1
  );

  let prog_file = Sys.argv.(1) in

  (* Convert OCaml list -> Coq list *)
  let rec to_coq_list = function
    | [] -> Nil
    | x :: xs -> Cons (x, to_coq_list xs)
  in

  let instrs = to_coq_list (Parser.parse_file prog_file) in

  let init = { memory = Nil; stack = Nil; halted = False } in
  let final_state = run init instrs in

  (* Correct handling of Coq prod (Pair) and list (Nil/Cons) *)
  let rec print_mem = function
    | Nil -> ()
    | Cons (Pair (k, v), rest) ->
        Printf.printf "MEM[%d] = %d\n" k v;
        print_mem rest
  in

  print_mem final_state.memory
