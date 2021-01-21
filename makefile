SHELL := /usr/bin/env bash

# dot, neato, twopi, circo, fdp, sfdp, patchwork, osage
DOT ?= dot

# for dot2tex
# dot, neato, twopi, circo, fdp
PROG ?= twopi
# pgf, pstricks, tikz
FORMAT ?= tikz

DOTs = $(wildcard *.dot)
TeXs = $(patsubst %.dot,%.tex,$(DOTs))
PDFs = $(patsubst %.dot,%.pdf,$(DOTs))

pdf: $(PDFs)

# %.pdf: %.dot
	# $(DOT) -T pdf $< -o $@

# always convert to xdot first as dot2tex sometimes fail to detect it is in plain dot format
%.tex: %.dot
	$(PROG) -T xdot $< | \
	dot2tex --autosize --format $(FORMAT) --prog $(PROG) > $@

%.pdf: %.tex
	latexmk -pdf $<

clean:
	find -name '*.tex' -exec latexmk -C {} +
	rm -f $(TeXs) $(PDFs) *.aux *.fdb_latexmk *.fls *.log

print-%:
	$(info $* = $($*))
