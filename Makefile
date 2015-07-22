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

debug:
	pdflatex -file-line-error openmp.tex

clean:
	rm -f openmp.pdf openmp.toc openmp.idx openmp.aux openmp.ilg openmp.ind openmp.out openmp.log openmp-diff.pdf openmp-diff-traditional.pdf openmp-diff-nodel.pdf

#NOTE: set these either as environment variables or on the command line, 
#      DO NOT change these default values and check them in
#      Either of these work:
#
#      DIFF_FROM=upstream/master make openmp-diff.pdf
#
#      make DIFF_FROM=upstream/master make openmp-diff.pdf
#
DIFF_FROM:=master
DIFF_TO:=HEAD
DIFF_TYPE:=UNDERLINE

COMMON_DIFF_OPTS:=--math-markup=whole  --append-safecmd=ld-safe.txt --append-textcmd=plc,code,glossaryterm  --exclude-textcmd=section,subsection,subsubsection,vcode \
			--config='PICTUREENV="(?:picture|DIFnomarkup|boxedcode)[\w\d*@]*"'
GIT_DIFF_OPTS:=${COMMON_DIFF_OPTS} --ignore-latex-errors --main openmp.tex --latexdiff-flatten
VC_DIFF_OPTS:=${COMMON_DIFF_OPTS} --flatten --pdf --git

git-diff-all: openmp-diff.pdf openmp-diff-traditional.pdf openmp-diff-nodel.pdf

openmp-diff.pdf: openmp.pdf
	git latexdiff --output $@ --type="${DIFF_TYPE}" ${GIT_DIFF_OPTS}  ${DIFF_FROM} ${DIFF_TO}

openmp-diff-minimal.pdf:
	latexdiff-vc ${VC_DIFF_OPTS} --only-changes --type="${DIFF_TYPE}" --subtype=ZLABEL -r ${DIFF_FROM} -r ${DIFF_TO} openmp.tex

openmp-diff-traditional.pdf: openmp.pdf
	git latexdiff --output $@ --type=CTRADITIONAL ${GIT_DIFF_OPTS}  ${DIFF_FROM} ${DIFF_TO}

openmp-diff-nodel.pdf: openmp.pdf
	git latexdiff --output $@ --preamble="$(shell pwd)/omp-latexdiff-preamble.tex" ${GIT_DIFF_OPTS}  ${DIFF_FROM} ${DIFF_TO}


