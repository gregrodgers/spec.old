FROM ubuntu:16.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    git-core ca-certificates make libpod-latex-perl \
    libalgorithm-diff-perl texlive-latex-base \
    texlive-fonts-recommended texlive-humanities \
    tex-gyre pdftk texlive-latex-extra openssh-client \
    texlive-latex-recommended texlive-generic-recommended && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
RUN git clone -b openmp-rebased 'http://github.com/jprotze/latexdiff.git' && \
    cd latexdiff && PATH=$PWD/dist/:$PATH make distribution && \
    mkdir ../latexdiff-dist && mv dist/* ../latexdiff-dist/ && \
    rm -rf /latexdiff
WORKDIR /spec
ENV PATH="/latexdiff-dist/:${PATH}"
CMD make
