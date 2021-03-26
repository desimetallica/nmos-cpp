# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.165.0/containers/cpp/.devcontainer/base.Dockerfile

# [Choice] Debian / Ubuntu version: debian-10, debian-9, ubuntu-20.04, ubuntu-18.04
ARG VARIANT="buster"
FROM mcr.microsoft.com/vscode/devcontainers/cpp:0-${VARIANT}

# [Optional] Uncomment this section to install additional packages.
 RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install python3-pip \
     libavahi-compat-libdnssd-dev \
     python3-setuptools

RUN pip3 install conan

#RUN sudo ln -s /home/vscode/.local/bin/conan /usr/local/bin/conan