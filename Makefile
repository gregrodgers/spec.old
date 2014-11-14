# Makefile for the OpenMP specifications document in LaTex format.
# For more information, see the master document, openmp.tex.

all: openmp.pdf

.PHONY: clean quick all git-diff-all

CHAPTERS=titlepage.tex \
	ch1-introduction.tex \
	ch2-directives.tex \
	ch3-runtimeLibrary.tex \
	ch4-environmentVariables.tex \
	appendix-A-stubs.tex \
	appendix-B-grammar.tex \
	appendix-C-InterfaceDeclarations.tex \
	appendix-D-ImplementationDefined.tex \
	appendix-E-FeaturesHistory.tex

openmp.pdf: $(CHAPTERS) openmp.sty openmp.tex openmp-index.ist worksharing-schedule-loop.tex openmp-logo.png Makefile
	-pdflatex -interaction=batchmode -file-line-error openmp.tex
	-makeindex -s openmp-index.ist openmp.idx
	-pdflatex -interaction=batchmode -file-line-error openmp.tex
	-pdflatex -interaction=batchmode -file-line-error openmp.tex

quick:
	pdflatex -interaction=batchmode -file-line-error openmp.tex

clean:
	rm -f openmp.pdf openmp.toc openmp.idx openmp.aux openmp.ilg openmp.ind openmp.out openmp.log openmp-diff.pdf openmp-diff-traditional.pdf openmp-diff-nodel.pdf

DIFF_OPTS:=--ignore-latex-errors --main openmp.tex --latexdiff-flatten --math-markup=whole --append-safecmd=ld-safe.txt --append-textcmd=plc,code,glossaryterm --exclude-textcmd=section,subsection,subsubsection

DIFF_FROM:=master
DIFF_TO:=HEAD
DIFF_TYPE:=UNDERLINE

git-diff-all: openmp-diff.pdf openmp-diff-traditional.pdf openmp-diff-nodel.pdf

openmp-diff.pdf: openmp.pdf
	git latexdiff --output $@ --type="${DIFF_TYPE}" ${DIFF_OPTS}  ${DIFF_FROM} ${DIFF_TO}

openmp-diff-traditional.pdf: openmp.pdf
	git latexdiff --output $@ --type=CTRADITIONAL ${DIFF_OPTS}  ${DIFF_FROM} ${DIFF_TO}

openmp-diff-nodel.pdf: openmp.pdf
	git latexdiff --output $@ --preamble="$(shell pwd)/omp-latexdiff-preamble.tex" ${DIFF_OPTS}  ${DIFF_FROM} ${DIFF_TO}


