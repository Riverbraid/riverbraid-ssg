#!/usr/bin/env bash
set -e
echo "== [1/3] Compiling Formal Core (Coq) =="
coqc formal/VM.v

echo "== [2/3] Compiling Native Runtime (OCaml) =="
cd runtime
ocamlc -c ssg_vm.mli ssg_vm.ml
ocamlc -c log.ml
ocamlc -c parser.ml
ocamlc -c main.ml
ocamlc -o ../riverbraid_vm unix.cma ssg_vm.cmo log.cmo parser.cmo main.cmo
cd ..

echo "== [3/3] Build Complete =="
./scripts/benchmark.sh
