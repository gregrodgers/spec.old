FROM ubuntu
RUN apt-get update &&\
    apt-get install --no-install-recommends -y \
    git-core ca-certificates make libpod-latex-perl \
    libalgorithm-diff-perl texlive-latex-base \
    texlive-fonts-recommended texlive-humanities \
    tex-gyre pdftk texlive-latex-extra \
    texlive-latex-recommended texlive-generic-recommended &&\
    rm -rf /var/lib/apt/lists/*
RUN git clone -b openmp 'http://github.com/jprotze/latexdiff.git' && cd latexdiff && PATH=$PWD/dist/:$PATH make distribution
WORKDIR /spec
ENV PATH="${PWD}/latexdiff/dist/:${PATH}"
CMD make
