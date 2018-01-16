OCB_FLAGS = -I src
OCB = ocamlbuild $(OCB_FLAGS)

all: byte

byte:
	$(OCB) main.byte

clean:
	$(OCB) -clean
