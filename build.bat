@echo off
rem Build the document on Windows
rem
rem Docker for Windows in the default search path is required.
rem In contrast to Makefile.docker, this does not require GNU make on the
rem Windows system.
rem
rem Usage:
rem
rem  build
rem    or
rem  build openmp.pdf
rem    Build the full specification openmp.pdf.
rem
rem  build [DIFF_TO=<git tree-ish>] [DIFF_FROM=<git tree-ish>] openmp-diff-full.pdf
rem    Build the full specification including the differences between the
rem    versions.
rem
rem  build [DIFF_TO=<git tree-ish>] [DIFF_FROM=<git tree-ish>] openmp-diff-abridged.pdf
rem    Build a comparison pdf between the versions including only pages that
rem    have differences differences.
rem
rem  Generally, all targets in Makefile can be used.
rem
docker run -v %cd%:/spec --rm -it openmp/spec-build make %*

