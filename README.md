# An NMOS C++ Implementation for remote camera control [![Build Status](https://github.com/desimetallica/nmos-cpp/workflows/build-test/badge.svg)][build-test]
[build-test]: https://github.com/desimetallica/nmos-cpp/actions?query=workflow%3Abuild-test

## Introduction

The 5G-Records nmos-cpp software is modified version of the open source Sony nmos-cpp software available on the Sony git repository ( https://github.com/sony/nmos-cpp ) and is subject to the open source license agreement described in the repository.

The original nmos-cpp software creates a nmos-node and nmos-registry software. The nmos-node runs on a local media device and registers the device with the nmos-registry software running on separate server. Register devices can then be controlled by the nmos-js Ctrl App ( https://github.com/sony/nmos-js ).

The current development has been made with Visul Studio Code Insiders:

- The [.vscode](.vscode) folder includes configurations of the workspace.
- The [.devcontainer](.devcontainer) folder includes the configurations related to the develop container used by VsCode and some extension used by the editor.
- The project provides also some dockerfile to build the images and run the examples nodes.

The source code has been modified to include some functionalities required and addittional examples nodes has been created to provide an environment to test the funcionalities of the remote camera control setup.

- Imported a Mqtt library paho-mqtt-c/1.3.8 and paho-mqtt-cpp/1.2.0 in order to connect to remote MQTT server.
- Created a proper API at node_implementation.cpp level that enables the user to cause an IS-07 event to be emitted by posting a string to a specific port.
- Created the [nmos-cpp-sender](/Development/nmos-cpp-sender/node_implementation.cpp) provides an IS-07 source of events made for controlling scope
- Created the [nmos-cpp-receiver](/Development/nmos-cpp-receiver/node_implementation.cpp) provides an IS-07 receiver of events in this node it is also present an MQTT publisher designed to interact with a remote MQTT server

Both sender and receiver nodes can be packeged inside a docker image, you can build by yourself the image with the provided dockerfile.

## Build and run docker images

Note that to build the context shoulde be ./nmos-cpp directory:

```bash
docker build -f ./Development/nmos-cpp-receiver/dockerfile --tag=vsc-nmos-cpp-receiver:cameraControl .
```  

```bash
docker build -f ./Development/nmos-cpp-sender/dockerfile --tag=vsc-nmos-cpp-sender:cameraControl .
```  

Dev images are faster to build based on Ubuntu-20.04:

```bash 
docker build -f ./Development/nmos-cpp-receiver/development.dockerfile --tag=nmos-cpp-camera-control:receiver-dev .
```  

```bash 
docker build -f ./Development/nmos-cpp-receiver/development.dockerfile --tag=nmos-cpp-camera-control:receiver-dev . 
```  

### Run:
Nodes:
```bash
docker run --restart unless-stopped -d --net=bridge -v "/var/run/dbus:/var/run/dbus" -v "/var/run/avahi-daemon/socket:/var/run/avahi-daemon/socket" -v "./nmos-cpp/Development/nmos-cpp-receiver/receiver.json:/workspace/nmos-cpp/build/node.json" --privileged --name=nmos-cpp-receiver vsc-nmos-cpp-receiver:cameraControl
```

```bash
docker run --restart unless-stopped -d --net=bridge -v "/var/run/dbus:/var/run/dbus" -v "/var/run/avahi-daemon/socket:/var/run/avahi-daemon/socket" -v "./nmos-cpp/Development/nmos-cpp-sender/sender.json:/workspace/nmos-cpp/build/node.json" --privileged --name=nmos-cpp-sender vsc-nmos-cpp-seder:cameraControl
```

Registry:
```bash
docker run --restart unless-stopped -d --net=bridge --privileged -e "RUN_NODE=FALSE" -v "./nmos-cpp/Development/nmos-cpp-registry/registry.json:/home/registry.json" -p 8080:8080 -p 8081:8081 --name docker-easy-nmos-registry rhastie/nmos-cpp:latest
```


## Test
To check connectivty between the two NMOS nodes you can connect them via Nmos registry. Next you can check the event emission by running a CURL on the ip of the sender:

```bash
curl -d "cy-rio-15-173/1ep1mdy/camhead/action/mult/export,2.9" -X POST http://172.17.0.2:9999/control
```
Please note that the message format should be a couple [topic,value], in this way the receiver can push correct value into topic of remote MQTT server. To check the output on receiver you have to connect them from a registry frontend usually the Nvidia can do the job. 

Check under receiver tab -> sony-nmos-receiver/receiver/x0 -> activate.

By subscribing on destination MQTT server it is possibile to check if the event has been posted into the right topic:

```bash
mosquitto_sub -h 10.54.128.42 -P 1883 -v -t \#
```
