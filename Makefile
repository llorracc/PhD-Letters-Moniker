# make / make letter : build Letter.pdf (./Letter-make.sh)
# make clean         : remove LaTeX's auxiliary files
# make test          : check the LaTeX installation (as in the dev container)
.PHONY: letter clean test help
letter:
	./Letter-make.sh

clean:
	latexmk -C Letter
	cd Subfiles && ../Subfiles.sh

test:
	bash .devcontainer/test-container.sh

help:
	@sed -n '1,3p' Makefile
