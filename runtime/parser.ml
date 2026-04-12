open Ssg_vm

let parse_instruction line =
  let parts = String.split_on_char ' ' (String.trim line) in
  match parts with
  | ["PUSH"; v]  -> Push (int_of_string v)
  | ["STORE"; k] -> Store (int_of_string k)
  | ["LOAD"; k]  -> Load (int_of_string k)
  | ["HASH"]     -> Hash
  | ["HALT"]     -> Halt
  | [] | [""]    -> Halt
  | _            -> failwith ("Invalid instruction format: " ^ line)

let parse_file filename =
  let chan = open_in filename in
  let rec loop acc =
    try
      let line = input_line chan in
      let trimmed = String.trim line in
      if trimmed = "" || (String.length trimmed > 0 && trimmed.[0] = '#') then loop acc
      else loop (parse_instruction trimmed :: acc)
    with End_of_file ->
      close_in chan;
      List.rev acc
  in
  loop []
