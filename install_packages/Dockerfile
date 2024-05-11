FROM fedora:26

RUN yum -y update; yum clean all; yum -y install openssh-server openssh-clients sudo; yum clean all

#Publish 22 container port to 8022
EXPOSE 22 8022
