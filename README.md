The OpenMP Specification
=========================
LaTex files for OpenMP Specification, starting with verified 4.0 conversion

Dependencies
------------
The following packages provide the necessary components to build the LaTeX OpenMP specification.
While the package names provided below are for Debian based distributions, other
package managers should provide TeX packages with similar names:
 * texlive-latex-base
 * texlive-fonts-recommended
 * texlive-humanities
 * texlive-gyre

Or, if you prefer to download a rather large set of packages:
 * texlive-full

Building the Specification
--------------------------
Simply run `make` from the top level 'spec' directory.  The result should be a
PDF version of the specification: openmp.pdf.
