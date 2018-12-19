# Makefile for the OpenMP specifications document in LaTex format.
# For more information, see the master document, openmp.tex.

all: openmp.pdf

# shortcuts for the most common make targets in use
include version.mk
full: openmp.pdf
release: clean openmp.pdf
release: VERSIONMACRO=$(RELEASEMACRO)
diff: openmp-diff-abridged.pdf

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
         appendices/ompt_frames.tex \
         directives.tex \
         directives/directives_cancellation.tex \
         directives/directives_combined.tex \
         directives/directives_common.tex \
         directives/directives_data_environment.tex \
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
         ompd.tex \
         ompt.tex \
         ompt/foundation.tex \
         ompt/frames.tex \
         ompd/ompd_activating_a_third_party_tool.tex \
         ompd/ompd_data_types_for_third_party_tools.tex \
         ompd/ompd_introduction.tex \
         ompd/ompd_runtime_entry_points.tex \
         ompd/ompd_third_party_callback_interface.tex \
         ompd/ompd_third_party_tool_interface_routines.tex \
         ompd/ompd_dll.tex \
         ompt/start_tool.tex \
         ompt/thread_states.tex \
         ompt/ompt_callbacks.tex \
         ompt/ompt_common.tex \
         ompt/ompt_entrypoints.tex \
         ompt/wait_id.tex

# check for branches names with "ticket_XXX"
DIFF_TICKET_ID=$(shell git rev-parse --abbrev-ref HEAD | grep "^ticket_[0-9]*" | sed 's/\(ticket_[0-9]*\)_.*\|\(ticket_[0-9]*\)/\1\2/')
# for release do something like:  make OMPVERSION="Version 5.0 Public Comment Draft, July 2018"

openmp.pdf: $(CHAPTERS) $(TEXFILES) openmp.sty openmp-index.ist openmp-logo.png Makefile
	-pdflatex -shell-escape -synctex=1 -interaction=batchmode -draftmode -file-line-error $(VERSIONMACRO)
	-makeindex -s openmp-index.ist openmp.idx
	-pdflatex -shell-escape -synctex=1 -interaction=batchmode -draftmode -file-line-error $(VERSIONMACRO)
	-pdflatex -shell-escape -synctex=1 -interaction=batchmode -file-line-error $(VERSIONMACRO)
	if [ "x$(DIFF_TICKET_ID)" != "x" ]; then cp $@ ${@:.pdf=-$(DIFF_TICKET_ID).pdf}; fi
	@if grep --quiet "LaTeX Warning: Label" openmp.log; then \
		grep "LaTeX Warning: Label" openmp.log; \
         fi
	@if grep --quiet "LaTeX Warning: Reference" openmp.log; then \
		grep "LaTeX Warning: Reference" openmp.log | sed 's/ on .*/ is undefined/' ; \
	 fi

quick:
	pdflatex -shell-escape -synctex=1 -interaction=batchmode -file-line-error -project=openmp $(VERSIONMACRO)
	if [ "x$(DIFF_TICKET_ID)" != "x" ]; then cp $@ ${@:.pdf=-$(DIFF_TICKET_ID).pdf}; fi

debug:
	pdflatex -shell-escape -synctex=1 -file-line-error -project=openmp $(VERSIONMACRO)

context_definitions: context_definitions.pdf

context_definitions.pdf: directives/context_definitions.tex openmp.sty
	pdflatex $<
	pdflatex $<
	pdflatex $<

all: openmp.pdf context_definitions

clean:
	rm -f openmp.pdf openmp.toc openmp.idx openmp.aux openmp.ilg openmp.ind openmp.out openmp.log openmp-diff.pdf
	rm -f openmp-diff-full.pdf openmp-diff-abridged.pdf openmp-diff-minimal.pdf
	rm -f openmp.synctex.gz
	rm -rf *.tmpdir
	rm -f openmp-ticket_*.pdf
	rm -f openmp-diff-abridged-ticket_*.pdf
	rm -f openmp-diff-full-ticket_*.pdf
	rm -f openmp-diff-minimal-ticket_*.pdf

realclean: clean
	find . \( -name \*.bak -or -name \*~ -or -name \*.swp \) -exec rm -v '{}' \;

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
                  --append-safecmd=plc,code,hcode,scode,pcode,splc \
                  --append-textcmd=subsubsubsection
                  #,binding,comments,constraints,crossreferences,descr,argdesc,effect,format,restrictions,summary,syntax,events,tools,record
#                  --exclude-textcmd=chapter,section,subsection,subsubsection,vcode
#COMMON_DIFF_OPTS:=--math-markup=whole \
#                  --append-safecmd=ld-safe.txt \
#                  --append-textcmd=plc,code,glossaryterm \
#                  --exclude-textcmd=section,subsection,subsubsection,vcode

VC_DIFF_OPTS:=${COMMON_DIFF_OPTS} --force -c latexdiff.cfg --flatten --type="${DIFF_TYPE}" --git --pdf  ${VC_DIFF_FROM} ${VC_DIFF_TO}  --subtype=ZLABEL --graphics-markup=none

VC_DIFF_MINIMAL_OPTS:= --only-changes --force

git-diff-fast-all: git-diff-fast git-diff-fast-minimal
git-diff-fast: openmp-diff-full.pdf
git-diff-fast-minimal: openmp-diff-abridged.pdf

%.tmpdir: $(wildcard *.sty) $(wildcard *.fls) $(wildcard *.png) $(wildcard *.aux) openmp.pdf
	mkdir -p $@/appendices
	mkdir -p $@/ompt
	cp -f $^ "$@/" || true
	cp -f appendices/callstack-cropped.pdf "$@/appendices"
	cp -f appendices/ompd_diagram.pdf "$@/appendices"
	cp -f ompt/ompt_flow_chart.pdf "$@/ompt"

openmp-diff-full.pdf: diff-fast-complete.tmpdir openmp.pdf
	env PATH="$(shell pwd)/util/latexdiff:$(PATH)" latexdiff-vc --fast -d $< ${VC_DIFF_OPTS} openmp.tex
	cp $</openmp.pdf $@
	if [ "x$(DIFF_TICKET_ID)" != "x" ]; then cp $@ ${@:.pdf=-$(DIFF_TICKET_ID).pdf}; fi

openmp-diff-abridged.pdf: diff-fast-minimal.tmpdir openmp.pdf
	env PATH="$(shell pwd)/util/latexdiff:$(PATH)" latexdiff-vc ${VC_DIFF_MINIMAL_OPTS} --fast -d $< ${VC_DIFF_OPTS} openmp.tex
	cp $</openmp.pdf $@
	if [ "x$(DIFF_TICKET_ID)" != "x" ]; then cp $@ ${@:.pdf=-$(DIFF_TICKET_ID).pdf}; fi

# Slow but portable diffs
openmp-diff-minimal.pdf: diffs-slow-minimal.tmpdir
	env PATH="$(shell pwd)/util/latexdiff:$(PATH)" latexdiff-vc ${VC_DIFF_MINIMAL_OPTS} -d $< ${VC_DIFF_OPTS} openmp.tex
	cp $</openmp.pdf $@
	if [ "x$(DIFF_TICKET_ID)" != "x" ]; then cp $@ ${@:.pdf=-$(DIFF_TICKET_ID).pdf}; fi

