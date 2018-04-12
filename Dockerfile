# docker build -t tectool .
FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y vim wget curl git  && \
    apt-get update 

# fix vim
RUN cd $HOME && \
    git clone https://github.com/fgypas/.vim.git && \
    cp $HOME/.vim/vimrc /etc/vim/vimrc.local


