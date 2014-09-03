# Makefile for the OpenMP specifications document in LaTex format. 
# For more information, see the master document, openmp-4.0.tex.

default: openmp-4.0.pdf

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

openmp-4.0.pdf: $(CHAPTERS) openmp.sty openmp-4.0.tex openmp-index.ist worksharing-schedule-loop.tex openmp-logo.png
	rm -f openmp-4.0.pdf openmp-4.0.toc openmp-4.0.idx openmp-4.0.aux openmp-4.0.ilg openmp-4.0.ind openmp-4.0.out openmp-4.0.log
	pdflatex -interaction=batchmode -file-line-error openmp-4.0.tex
	makeindex -s openmp-index.ist openmp-4.0.idx
	pdflatex -interaction=batchmode -file-line-error openmp-4.0.tex
	pdflatex -interaction=batchmode -file-line-error openmp-4.0.tex

quick:
	rm -f openmp-4.0.pdf openmp-4.0.toc openmp-4.0.idx openmp-4.0.aux openmp-4.0.ilg openmp-4.0.ind openmp-4.0.out openmp-4.0.log
	pdflatex -interaction=batchmode -file-line-error openmp-4.0.tex

clean:
	rm -f openmp-4.0.pdf openmp-4.0.toc openmp-4.0.idx openmp-4.0.aux openmp-4.0.ilg openmp-4.0.ind openmp-4.0.out openmp-4.0.log

