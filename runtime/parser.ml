open Ssg_vm

let parse_line line =
  match String.split_on_char ' ' (String.trim line) with
  | ["LOAD"; k] -> Load (int_of_string k)
  | ["STORE"; k] -> Store (int_of_string k)
  | ["HASH"] -> Hash
  | ["HALT"] -> Halt
  | _ -> failwith ("INVALID_INSTRUCTION: " ^ line)

let read_program filename =
  let ic = open_in filename in
  let rec loop acc =
    try
      let line = input_line ic in
      loop (parse_line line :: acc)
    with End_of_file ->
      close_in ic;
      List.rev acc
  in loop []
