COQ=coqc
OCAMLOPT=ocamlopt
FORMAL_DIR=formal
RUNTIME_DIR=runtime
TARGET=riverbraid_vm

all: clean build test

coq:
	$(COQ) -Q $(FORMAL_DIR) "" $(FORMAL_DIR)/VM.v
	$(COQ) -Q $(FORMAL_DIR) "" $(FORMAL_DIR)/Run.v
	$(COQ) -Q $(FORMAL_DIR) "" $(FORMAL_DIR)/Extract.v

ssg_vm.cmi:
	ocamlc -i ssg_vm.ml > ssg_vm.mli
	$(OCAMLOPT) -c ssg_vm.mli

ocaml: ssg_vm.cmi
	$(OCAMLOPT) -c ssg_vm.ml
	$(OCAMLOPT) -c -I . $(RUNTIME_DIR)/parser.ml
	$(OCAMLOPT) -c -I . -I $(RUNTIME_DIR) $(RUNTIME_DIR)/main.ml

link:
	$(OCAMLOPT) -o $(TARGET) ssg_vm.cmx $(RUNTIME_DIR)/parser.cmx $(RUNTIME_DIR)/main.cmx

build: coq ocaml link

test:
	printf "PUSH 42\nSTORE 0\nLOAD 0\nHALT\n" > test.ir
	./$(TARGET) test.ir

clean:
	rm -f *.cmx *.cmi *.o *.mli ssg_vm.ml $(TARGET) test.ir
	rm -f $(RUNTIME_DIR)/*.cmx $(RUNTIME_DIR)/*.cmi $(RUNTIME_DIR)/*.o
	rm -rf $(FORMAL_DIR)/*.vo $(FORMAL_DIR)/*.glob

.PHONY: all build clean test
