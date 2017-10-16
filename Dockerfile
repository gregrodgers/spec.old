FROM ubuntu
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    texlive-latex-base texlive-fonts-recommended \
    texlive-humanities tex-gyre latexdiff git-core\
    make pdftk texlive-latex-extra \
    texlive-latex-recommended texlive-generic-recommended \
    && \
    rm -rf /var/lib/apt/lists/*
VOLUME /spec
WORKDIR /spec
CMD make
