FROM ubuntu:18.04 

LABEL MAINTAINER="Fredy Samuel B Tarigan"

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/# deb/deb/g' /etc/apt/sources.list

RUN apt update -y \
    # prepare for systemd \
    && apt-get install -y systemd systemd-sysv \
    && apt-get upgrade -y \
    && apt-get install python3 python3-dev -y \
    && cd /lib/systemd/system/sysinit.target.wants/ \
    && ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 \
    rm -f /lib/systemd/system/multi-user.target.wants/*
    
RUN rm -rf /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/* \
    /lib/systemd/system/plymouth* \
    /lib/systemd/system/systemd-update-utmp*

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/lib/systemd/systemd"]