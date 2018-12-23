FROM daocloud.io/ubuntu:16.04

ENV REFRESHED_AT 2018-12-16

COPY sources.list.16.04 /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y shadowsocks polipo
COPY shadowsocks/sslocal.json /etc/shadowsocks/config.json
COPY shadowsocks/polipo /etc/polipo/config
COPY shadowsocks/ssctl /usr/local/bin/ssctl
RUN echo "alias http_proxy_on='export http_proxy=http://127.0.0.1:8123 && export https_proxy=https://127.0.0.1:8123'" >> /etc/bash.bashrc
RUN echo "alias http_proxy_off='export http_proxy= && export https_proxy='" >> /etc/bash.bashrc
RUN chmod +x /usr/local/bin/ssctl

RUN apt-get install -y git wget curl man pkg-config zip g++ zlib1g-dev unzip

RUN git config --global alias.st status
RUN git config --global alias.ci commit
RUN git config --global alias.co checkout

RUN apt-get install -y language-pack-zh-hans
RUN locale-gen zh_CN.UTF-8
RUN echo "export LC_ALL='zh_CN.utf8'" >> /root/.bashrc

RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq tzdata
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

RUN apt-get install -y apt-utils software-properties-common

RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update
RUN ssctl start && http_proxy=http://127.0.0.1:8123 https_proxy=https://127.0.0.1:8123 apt-get install -y python3.6 && ssctl stop
RUN curl https://bootstrap.pypa.io/ez_setup.py -o /tmp/ez_setup.py
RUN ssctl start && http_proxy=http://127.0.0.1:8123 https_proxy=https://127.0.0.1:8123 python3.6 /tmp/ez_setup.py && python3.6 -m easy_install pip && ssctl stop

COPY pip.conf /root/.pip/pip.conf

RUN pip3 install --upgrade pip
RUN pip3 install h5py pyyaml matplotlib sklearn six numpy wheel mock
RUN pip3 install tensorflow tensorflow_hub
RUN pip3 install Pillow Image

RUN apt-get install -y vim

RUN pip3 install keras pydot ipython
RUN pip3 install graphviz pydot-ng

RUN apt-get install -y graphviz
RUN pip3 install opencv-python pandas

RUN apt-get install -y iputils-ping

RUN pip3 install music21
RUN pip3 install emoji

WORKDIR /learning/projects
