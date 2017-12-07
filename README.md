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
    * tex-gyre
    * texlive-latex-extra
    * texlive-latex-recommended
    * texlive-generic-recommended

Or, if you prefer to download a rather large set of packages:
    * texlive-full

Building the diff PDFs also require the following:
    * latexdiff
    * pdftk

Building the Specification
--------------------------
Simply run `make` from the top level 'spec' directory.  The result should be a
PDF version of the specification: openmp.pdf.

Building using Docker
---------------------
If you do not wish to install the required packages on your machine you may
build the specification within a [docker](https://www.docker.com/) container.

    $ docker pull jefflarkin/openmp-spec

Then use Makefile.docker to build your targets, for instance

    $ make -f Makefile.docker
    $ make -f Makefile.docker openmp-diff-minimal.pdf

If you would prefer to build the docker container yourself, rather than pulling
from dockerhub, you can do the following:

    $ docker build -t openmp-spec:local .

To use the resulting container, you will need to use the -u option to `docker
run` to ensure the resulting files are owned by your user upon completion and
-v option to mount the `/spec` option in the container, for instance `-v
$PWD:/spec`. Please see Makefile.docker for an example.
