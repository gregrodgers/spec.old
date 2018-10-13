# This specifies the OpenMP version which shows in all builds
OMPVERSION=Version 5.0

# This specifies the document version which only shows in release builds
DOCVERSION=
DOCDATE=November 2018

GITREV=$(shell git rev-parse --short HEAD 2>/dev/null || echo out of git tree)

# these are the macros used to actually build the spec
VERSIONMACRO="\\def\\ompversion{$(OMPVERSION) -- GIT rev $(GITREV)}\\input{openmp}"
RELEASEMACRO="\\def\\ompversion{$(OMPVERSION) $(DOCVERSION) $(DOCDATE)}\\input{openmp}"

