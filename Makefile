OCB_FLAGS = -I src
OCB = ocamlbuild $(OCB_FLAGS)

all: native

native:
	$(OCB) main.native

clean:
	$(OCB) -clean
