FROM pditommaso/dkrbase
MAINTAINER Maria Chatzou <mxatzou@gmail.com>

RUN apt-get update -y --fix-missing && apt-get install -y \
    libboost-all-dev \
    git \
    cmake \
    libargtable2-dev

RUN git clone --depth 10 https://mariach@bitbucket.org/mariach/mega2.git mega && \
    cd mega/build &&\
    rm -r * &&\
    cmake .. &&\
    make tea &&\
    cp tea /usr/local/bin &&\
    rm -rf /mega/Homfam &&\
    cd ..

RUN cd clustal &&\
    ./configure &&\
    make &&\
    cp mega/clustal/src/clustalo /usr/local/bin/
