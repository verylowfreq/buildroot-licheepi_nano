FROM ubuntu:20.04

ARG USERID=1000
ARG USERNAME=builduser

RUN apt update && \
    apt install sudo

RUN echo ${USERNAME} ALL=NOPASSWD: ALL >> /etc/sudoers

RUN adduser --disabled-password --uid ${USERID} ${USERNAME} && \
    addgroup ${USERNAME} sudo

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt install -y build-essential git file wget cpio unzip rsync bc \
                libncurses-dev python3 python3-distutils python3-dev libssl-dev \
                swig fakeroot devscripts gawk dosfstools

RUN apt install -y locales && \
	locale-gen en_US.UTF-8 && \
	locale-gen ja_JP.UTF-8

RUN apt install -y vim

USER ${USERNAME}
WORKDIR /home/${USERNAME}

