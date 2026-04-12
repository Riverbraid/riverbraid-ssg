let log_file = "state.log"

let append entry =
  let oc = open_out_gen [Open_creat; Open_append] 0o644 log_file in
  output_string oc (entry ^ "\n");
  close_out oc
