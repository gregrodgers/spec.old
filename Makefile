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
         directives/directives_concurrent.tex \
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
         tool_support/tool_support_debug.tex \
         tool_support/ompd/ompd_activating_a_third_party_tool.tex \
         tool_support/ompd/ompd_data_types_for_third_party_tools.tex \
         tool_support/ompd/ompd_introduction.tex \
         tool_support/ompd/ompd_runtime_entry_points.tex \
         tool_support/ompd/ompd_third_party_callback_interface.tex \
         tool_support/ompd/ompd_third_party_tool_interface_routines.tex \
         environment_variables.tex \
         appendices/stubs.tex \
         appendices/stubs_ccpp.tex \
         appendices/stubs_fortran.tex \
         appendices/interface_declarations.tex \
         appendices/implementation_defined.tex \
         appendices/tool_support_frames.tex \
         appendices/features_history.tex

openmp.pdf: $(CHAPTERS) openmp.sty openmp-index.ist openmp-logo.png Makefile
	-pdflatex -synctex=1 -interaction=batchmode -file-line-error openmp.tex
	-makeindex -s openmp-index.ist openmp.idx
	-pdflatex -synctex=1 -interaction=batchmode -file-line-error openmp.tex
	-pdflatex -synctex=1 -interaction=batchmode -file-line-error openmp.tex

quick:
	pdflatex -synctex=1 -interaction=batchmode -file-line-error openmp.tex

debug:
	pdflatex -synctex=1 -file-line-error openmp.tex

clean:
	rm -f openmp.pdf openmp.toc openmp.idx openmp.aux openmp.ilg openmp.ind openmp.out openmp.log openmp-diff.pdf
	rm -f openmp-diff-full.pdf openmp-diff-abridged.pdf openmp-diff-minimal.pdf
	rm -f openmp.synctex.gz
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
else
    VC_DIFF_TO :=
endif
ifdef DIFF_FROM
    VC_DIFF_FROM := -r ${DIFF_FROM}
else
    VC_DIFF_FROM := -r master
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

VC_DIFF_OPTS:=${COMMON_DIFF_OPTS} -c latexdiff.cfg --flatten --type="${DIFF_TYPE}" --git --pdf  ${VC_DIFF_FROM} ${VC_DIFF_TO}  --subtype=ZLABEL --graphics-markup=none

VC_DIFF_MINIMAL_OPTS:= --only-changes

git-diff-fast-all: git-diff-fast git-diff-fast-minimal
git-diff-fast: openmp-diff-full.pdf
git-diff-fast-minimal: openmp-diff-abridged.pdf

%.tmpdir: $(wildcard *.sty) $(wildcard *.fls) $(wildcard *.png)
	mkdir -p $@/appendices
	cp -f $^ "$@/" || true
	cp -f appendices/callstack-cropped.pdf "$@/appendices"

openmp-diff-full.pdf: diff-fast-complete.tmpdir openmp.pdf
	latexdiff-vc --fast -d $< ${VC_DIFF_OPTS} openmp.tex
	cp $</openmp.pdf $@

openmp-diff-abridged.pdf: diff-fast-minimal.tmpdir
	latexdiff-vc ${VC_DIFF_MINIMAL_OPTS} --fast -d $< ${VC_DIFF_OPTS} openmp.tex
	cp $</openmp.pdf $@

# Slow but portable diffs
openmp-diff-minimal.pdf: diffs-slow-minimal.tmpdir
	latexdiff-vc ${VC_DIFF_MINIMAL_OPTS} -d $< ${VC_DIFF_OPTS} openmp.tex
	cp $</openmp.pdf $@

