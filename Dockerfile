# docker build -t tectool .
FROM ubuntu:16.04

# basic installation
RUN apt-get update && \
    apt-get install -y vim wget curl git build-essential python python-dev python-pip && \
    python -m pip install pip --upgrade && \
    python -m pip install wheel

# fix vim
RUN cd $HOME && \
    git clone https://github.com/fgypas/.vim.git && \
    cp $HOME/.vim/vimrc /etc/vim/vimrc.local

# install mirza
RUN wget http://www.clipz.unibas.ch/mirzag/mirza.tar.gz && \
    tar xzvf mirza.tar.gz && \
    rm mirza.tar.gz && \
    cd mirza && \
    ln -s make_html_noupdate.pl /usr/bin/make_html_noupdate.pl && \
    ln -s make_html_update.pl /usr/bin/make_html_update.pl && \
    ln -s parseInput.pl /usr/bin/parseInput.pl && \
    ln -s parser.sh /usr/bin/parser.sh && \
    ln -s sorttable.js /usr/bin/sorttable.js

# install contrafold
RUN wget http://contra.stanford.edu/contrafold/contrafold_v2_02.tar.gz && \
    tar xzvf contrafold_v2_02.tar.gz && \
    rm contrafold_v2_02.tar.gz && \
    cd contrafold/src && \
    sed -i 's/CXXFLAGS = -O3 -DNDEBUG -W -pipe -Wundef -Winline --param large-function-growth=100000 -Wall/CXXFLAGS = -O3 -DNDEBUG -W -pipe -Wundef -Winline --param large-function-growth=100000 -Wall -fpermissive/' Makefile && \
    sed -i 's/#include <vector>/#include <vector>\n#include <limits.h>\n/' Utilities.hpp && \
    make && \
    echo 'export PATH=/contrafold:$PATH' >> ~/.bashrc && \
    echo 'export PATH=/contrafold/src:$PATH' >> ~/.bashrc && \
    /bin/bash -c "source ~/.bashrc" && \
    cd ../../

# install mirzag and dependencies
RUN git clone -b cwl https://github.com/jsurkont/MIRZAG.git && \
    cd MIRZAG && \
    pip install -r requirements.txt && \
    echo 'export PATH=/MIRZAG/scripts:$PATH' >> ~/.bashrc && \
    /bin/bash -c "source ~/.bashrc"
