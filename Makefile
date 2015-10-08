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
	rm -f openmp.pdf openmp.toc openmp.idx openmp.aux openmp.ilg openmp.ind openmp.out openmp.log openmp-diff.pdf openmp-diff-traditional.pdf
	rm -f openmp-diff-full.pdf openmp-diff-abridged.pdf
	rm -rf *.tmpdir

#NOTE: set these either as environment variables or on the command line, 
#      DO NOT change these default values and check them in
#      Either of these work:
#
#      DIFF_FROM=upstream/master make openmp-diff.pdf
#
#      make DIFF_FROM=upstream/master make openmp-diff.pdf
#
ifdef DIFF_TO
VC_DIFF_TO := -r ${DIFF_TO}
ifndef DIFF_FROM
	#need a from to get to right, probably want master?
	VC_DIFF_FROM := -r master
endif
endif
ifdef DIFF_FROM
VC_DIFF_FROM := -r ${DIFF_FROM}
else
VC_DIFF_FROM := -r HEAD
endif

DIFF_FROM:=master
DIFF_TO:=HEAD
DIFF_TYPE:=UNDERLINE

COMMON_DIFF_OPTS:=--math-markup=whole \
                  --append-safecmd=ld-safe.txt \
                  --append-textcmd=plc,code,glossaryterm \
                  --exclude-textcmd=section,subsection,subsubsection,vcode

GIT_DIFF_OPTS:=${COMMON_DIFF_OPTS} --config=latexdiff.cfg --ignore-latex-errors --main openmp.tex --latexdiff-flatten
VC_DIFF_OPTS:=${COMMON_DIFF_OPTS} -c latexdiff.cfg --type="${DIFF_TYPE}" --flatten --git --pdf  ${VC_DIFF_FROM} ${VC_DIFF_TO}

VC_DIFF_MINIMAL_OPTS:= --only-changes --subtype=ZLABEL

git-diff-fast-all: git-diff-fast git-diff-fast-minimal
git-diff-fast: openmp-diff-full.pdf
git-diff-fast-minimal: openmp-diff-abridged.pdf

%.tmpdir: $(wildcard *.sty) $(wildcard *.fls) $(wildcard *.png)
	mkdir -p $@
	cp -f $^ "$@/" || true

openmp-diff-full.pdf: diff-fast-complete.tmpdir openmp.pdf
	latexdiff-vc --fast -d $< ${VC_DIFF_OPTS} openmp.tex
	cp $</openmp.pdf $@

openmp-diff-abridged.pdf: diff-fast-minimal.tmpdir openmp.pdf
	latexdiff-vc ${VC_DIFF_MINIMAL_OPTS} --fast -d $< ${VC_DIFF_OPTS} openmp.tex
	cp $</openmp.pdf $@

# Slow but portable diffs

git-diff-all: openmp-diff.pdf openmp-diff-traditional.pdf

openmp-diff.pdf: openmp.pdf
	git latexdiff --output $@ --type="${DIFF_TYPE}" ${GIT_DIFF_OPTS}  ${DIFF_FROM} ${DIFF_TO}

openmp-diff-minimal.pdf: diffs-slow-minimal.tmpdir openmp.pdf
	latexdiff-vc ${VC_DIFF_MINIMAL_OPTS} -d $< ${VC_DIFF_OPTS} openmp.tex
	cp $</openmp.pdf $@

openmp-diff-traditional.pdf: openmp.pdf
	git latexdiff --output $@ --type=CTRADITIONAL ${GIT_DIFF_OPTS}  ${DIFF_FROM} ${DIFF_TO}

