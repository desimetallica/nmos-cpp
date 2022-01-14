FROM ubuntu:20.04

#RUN sudo ln -s /home/vscode/.local/bin/conan /usr/local/bin/conan

#note use context ./nmos-cpp directory

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y --no-install-recommends \
    openssl make nano curl jq gnupg \
    dbus avahi-daemon libavahi-compat-libdnssd-dev libnss-mdns &&\
    #cd /home/mDNSResponder-878.260.1/mDNSPosix && make os=linux install && \
    #cd /home && rm -rf /home/mDNSResponder-878.260.1 /etc/nsswitch.conf.pre-mdns && \
    #curl -sS -k "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x77b7346a59027b33c10cafe35e64e954262c4500" | apt-key add - && \
    #echo "deb http://ppa.launchpad.net/mosquitto-dev/mosquitto-ppa/ubuntu bionic main" | tee /etc/apt/sources.list.d/mosquitto.list && \
    #apt-get update && apt-get install -y --no-install-recommends mosquitto && \
    apt-get remove --purge -y make gnupg && \
    apt-get autoremove -y && \
    apt-get clean -y --no-install-recommends && \
    apt-get autoclean -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/ && rm -rf /usr/share/man/ && rm -rf /usr/share/locale/ && \
    rm -rf /usr/local/share/man/* && rm -rf /usr/local/share/.cache/*

COPY ./build/nmos-cpp-sender /opt

COPY ./Development/nmos-cpp-sender/sender-dev.json /opt/node.json

WORKDIR /opt

ENTRYPOINT /opt/nmos-cpp-sender node.json