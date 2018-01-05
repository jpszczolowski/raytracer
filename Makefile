OCB = ocamlbuild

all: byte

byte:
	$(OCB) main.byte

clean:
	$(OCB) -clean