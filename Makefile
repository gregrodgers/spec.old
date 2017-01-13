# Makefile for the OpenMP specifications document in LaTex format.
# For more information, see the master document, openmp.tex.

all: openmp.pdf

.PHONY: clean quick all git-diff-all

CHAPTERS=openmp.tex \
         titlepage.tex \
         introduction.tex \
         directives.tex \
         directives/worksharing-schedule-loop.tex \
         directives/directives_common.tex \
         directives/directives_parallel.tex \
         directives/directives_worksharing.tex \
         directives/directives_simd.tex \
         directives/directives_tasking.tex \
         directives/directives_device.tex \
         directives/directives_combined.tex \
         directives/directives_if.tex \
         directives/directives_synchronization.tex \
         directives/directives_cancellation.tex \
         directives/directives_data_environment.tex \
         directives/directives_nesting.tex \
         directives/directives_udr.tex \
         runtime_library.tex \
         runtime_library/runtime_library_execution.tex \
         runtime_library/runtime_library_others.tex \
         tool_support.tex \
         tool_support/tool_support_common.tex \
         tool_support/tool_support_callbacks.tex \
         tool_support/tool_support_entrypoints.tex \
         environment_variables.tex \
         appendices/stubs.tex \
         appendices/interface_declarations.tex \
         appendices/implementation_defined.tex \
         appendices/tool_support_frames.tex \
         appendices/features_history.tex

openmp.pdf: $(CHAPTERS) openmp.sty openmp-index.ist openmp-logo.png Makefile
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
        # need a from to get to right, probably want master?
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
                  --append-textcmd=plc,code,glossaryterm \
                  --exclude-textcmd=chapter,section,subsection,subsubsection,vcode
#COMMON_DIFF_OPTS:=--math-markup=whole \
#                  --append-safecmd=ld-safe.txt \
#                  --append-textcmd=plc,code,glossaryterm \
#                  --exclude-textcmd=section,subsection,subsubsection,vcode

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

