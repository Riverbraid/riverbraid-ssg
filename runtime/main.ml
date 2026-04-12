open Ssg_vm

let () =
  if Array.length Sys.argv < 2 then
    (print_endline "Usage: riverbraid_vm <program.ir>"; exit 1);
  
  let filename = Sys.argv.(1) in
  let program = Parser.read_program filename in
  
  Log.append (Printf.sprintf "EXEC:%s:TIMESTAMP:%f" filename (Unix.gettimeofday ()));
  
  let initial_state = { memory = []; stack = []; halted = false } in
  let final_state = run program initial_state in
  
  if final_state.halted then 
    print_endline "--- EXECUTION COMPLETE: STATIONARY ---"
  else 
    print_endline "--- EXECUTION COMPLETE: ACTIVE ---"
