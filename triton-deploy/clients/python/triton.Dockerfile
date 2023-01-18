FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y libgl1-mesa-glx software-properties-common

RUN apt-get install -y --no-install-recommends \
    libgcc-9-dev \
    libssl-dev \
    libncurses5-dev \
    libffi-dev \
    libsqlite3-dev \
    libreadline-dev \
    tk-dev \
    libbz2-dev \
    zlib1g-dev \
    xz-utils

RUN  add-apt-repository -y ppa:deadsnakes/ppa
RUN  apt-get update

# Install python3
RUN apt-get install -y --no-install-recommends \
      python3.7 \
      python3.7-dev \
      python3-wheel \
      python3-pip \
      python3.7-distutils

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PyPI packages
RUN python3.7 -m pip install --upgrade pip
COPY requirements.txt /tmp/requirements.txt
RUN python3.7 -m pip install -r /tmp/requirements.txt

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1

ENV PATH="/usr/local/bin:${PATH}"


CMD [ "python3" ]

