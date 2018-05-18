# Makefile for the OpenMP specifications document in LaTex format.
# For more information, see the master document, openmp.tex.

all: openmp.pdf

.PHONY: clean quick all git-diff-all

TEXFILES=openmp.tex \
         titlepage.tex \
         appendices/features_history.tex \
         appendices/implementation_defined.tex \
         appendices/interface_declarations.tex \
         appendices/ompd_diagram.tex \
         appendices/stubs.tex \
         appendices/stubs_ccpp.tex \
         appendices/stubs_fortran.tex \
         appendices/tool_support_frames.tex \
         directives.tex \
         directives/directives_cancellation.tex \
         directives/directives_combined.tex \
         directives/directives_common.tex \
         directives/directives_concurrent.tex \
         directives/directives_data_environment.tex \
         directives/directives_declare.tex \
         directives/directives_device.tex \
         directives/directives_if.tex \
         directives/directives_loops.tex \
         directives/directives_mm.tex \
         directives/directives_nesting.tex \
         directives/directives_parallel.tex \
         directives/directives_synchronization.tex \
         directives/directives_tasking.tex \
         directives/directives_teams.tex \
         directives/directives_worksharing.tex \
         directives/worksharing-schedule-loop.tex \
         environment_variables.tex \
         introduction.tex \
         introduction/introduction_compliance.tex \
         introduction/introduction_execution_model.tex \
         introduction/introduction_glossary.tex \
         introduction/introduction_introduction.tex \
         introduction/introduction_memory_model.tex \
         introduction/introduction_normative_refs.tex \
         introduction/introduction_organization.tex \
         introduction/introduction_scope.tex \
         introduction/introduction_tools.tex \
         runtime_library.tex \
         runtime_library/runtime_library_device_mem.tex \
         runtime_library/runtime_library_execution.tex \
         runtime_library/runtime_library_mm.tex \
         runtime_library/runtime_library_others.tex \
         runtime_library/runtime_library_tools.tex \
         tool_support.tex \
         tool_support/foundation.tex \
         tool_support/frames.tex \
         tool_support/ompd/ompd_activating_a_third_party_tool.tex \
         tool_support/ompd/ompd_data_types_for_third_party_tools.tex \
         tool_support/ompd/ompd_introduction.tex \
         tool_support/ompd/ompd_runtime_entry_points.tex \
         tool_support/ompd/ompd_third_party_callback_interface.tex \
         tool_support/ompd/ompd_third_party_tool_interface_routines.tex \
         tool_support/ompd_dll.tex \
         tool_support/start_tool.tex \
         tool_support/thread_states.tex \
         tool_support/tool_support_callbacks.tex \
         tool_support/tool_support_common.tex \
         tool_support/tool_support_debug.tex \
         tool_support/tool_support_entrypoints.tex \
         tool_support/wait_id.tex

# check for branches names with "ticket_XXX"
DIFF_TICKET_ID=$(shell git rev-parse --abbrev-ref HEAD | grep "^ticket_[0-9]*" | sed 's/\(ticket_[0-9]*\)_.*\|\(ticket_[0-9]*\)/\1\2/')

openmp.pdf: $(CHAPTERS) $(TEXFILES) openmp.sty openmp-index.ist openmp-logo.png Makefile
	-pdflatex -synctex=1 -interaction=batchmode -draftmode -file-line-error openmp.tex
	-makeindex -s openmp-index.ist openmp.idx
	-pdflatex -synctex=1 -interaction=batchmode -draftmode -file-line-error openmp.tex
	-pdflatex -synctex=1 -interaction=batchmode -file-line-error openmp.tex
	if [ "x$(DIFF_TICKET_ID)" != "x" ]; then cp $@ ${@:.pdf=-$(DIFF_TICKET_ID).pdf}; fi

quick:
	pdflatex -synctex=1 -interaction=batchmode -file-line-error openmp.tex

debug:
	pdflatex -synctex=1 -file-line-error openmp.tex

clean:
	rm -f openmp.pdf openmp.toc openmp.idx openmp.aux openmp.ilg openmp.ind openmp.out openmp.log openmp-diff.pdf
	rm -f openmp-diff-full.pdf openmp-diff-abridged.pdf openmp-diff-minimal.pdf
	rm -f openmp.synctex.gz
	rm -rf *.tmpdir
	rm -f openmp-ticket_*.pdf
	rm -f openmp-diff-abridged-ticket_*.pdf
	rm -f openmp-diff-full-ticket_*.pdf
	rm -f openmp-diff-minimal-ticket_*.pdf

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

DIFF_TO:=HEAD
DIFF_FROM:=master
DIFF_TYPE:=UNDERLINE

COMMON_DIFF_OPTS:=--math-markup=whole  \
                  --append-safecmd=plc,code,hcode,scode,pcode,splc,glossaryterm \
                  --append-textcmd=subsubsubsection
                  #,binding,comments,constraints,crossreferences,descr,argdesc,effect,format,restrictions,summary,syntax,events,tools,record
#                  --exclude-textcmd=chapter,section,subsection,subsubsection,vcode
#COMMON_DIFF_OPTS:=--math-markup=whole \
#                  --append-safecmd=ld-safe.txt \
#                  --append-textcmd=plc,code,glossaryterm \
#                  --exclude-textcmd=section,subsection,subsubsection,vcode

VC_DIFF_OPTS:=${COMMON_DIFF_OPTS} -c latexdiff.cfg --flatten --type="${DIFF_TYPE}" --git --pdf  ${VC_DIFF_FROM} ${VC_DIFF_TO}  --subtype=ZLABEL --graphics-markup=none

VC_DIFF_MINIMAL_OPTS:= --only-changes

git-diff-fast-all: git-diff-fast git-diff-fast-minimal
git-diff-fast: openmp-diff-full.pdf
git-diff-fast-minimal: openmp-diff-abridged.pdf

%.tmpdir: $(wildcard *.sty) $(wildcard *.fls) $(wildcard *.png) $(wildcard *.aux) openmp.pdf
	mkdir -p $@/appendices
	cp -f $^ "$@/" || true
	cp -f appendices/callstack-cropped.pdf "$@/appendices"
	cp -f appendices/ompd_diagram.pdf "$@/appendices"

openmp-diff-full.pdf: diff-fast-complete.tmpdir openmp.pdf
	env PATH="$(PWD)/util/latexdiff:$(PATH)" latexdiff-vc --fast -d $< ${VC_DIFF_OPTS} openmp.tex
	cp $</openmp.pdf $@
	if [ "x$(DIFF_TICKET_ID)" != "x" ]; then cp $@ ${@:.pdf=-$(DIFF_TICKET_ID).pdf}; fi

openmp-diff-abridged.pdf: diff-fast-minimal.tmpdir openmp.pdf
	env PATH="$(PWD)/util/latexdiff:$(PATH)" latexdiff-vc ${VC_DIFF_MINIMAL_OPTS} --fast --debug -d $< ${VC_DIFF_OPTS} openmp.tex
	cp $</openmp.pdf $@
	if [ "x$(DIFF_TICKET_ID)" != "x" ]; then cp $@ ${@:.pdf=-$(DIFF_TICKET_ID).pdf}; fi

# Slow but portable diffs
openmp-diff-minimal.pdf: diffs-slow-minimal.tmpdir
	env PATH="$(PWD)/util/latexdiff:$(PATH)" latexdiff-vc ${VC_DIFF_MINIMAL_OPTS} -d $< ${VC_DIFF_OPTS} openmp.tex
	cp $</openmp.pdf $@
	if [ "x$(DIFF_TICKET_ID)" != "x" ]; then cp $@ ${@:.pdf=-$(DIFF_TICKET_ID).pdf}; fi

