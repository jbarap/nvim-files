FROM ubuntu:20.04

RUN apt-get update && \
    apt-get upgrade -y

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV TZ=America/Mexico_City

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get install -y git \
                       unzip \
                       curl \
                       python-dev \
                       python3-dev \
                       software-properties-common

# deps installer requirements
RUN apt-get install -y curl \
                       golang \
                       nodejs \
                       npm \
                       python3 \
                       python3-pip \
                       python3-venv

RUN add-apt-repository ppa:neovim-ppa/unstable && \
    apt-get update && \
    apt-get install -y neovim

RUN git clone https://github.com/JA-Bar/nvim-files ~/.config/nvim

CMD bash
