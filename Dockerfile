FROM debian:stretch
MAINTAINER Erwan Arzur <erwan@arzur.net>

# Install transmission
RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends curl procps \
                transmission-daemon \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    apt-get clean && \
    dir="/var/lib/transmission-daemon" && \
    rm -rf $dir/info && \
    rm -rf $dir/.config && \
    usermod -d $dir debian-transmission && \
    test -d $dir/info || mkdir -p $dir/info && \
    test -d $dir/downloads || mkdir -p $dir/downloads && \
    test -d $dir/incomplete  || mkdir -p $dir/incomplete && \
    test -d $dir/info/blocklists || mkdir -p $dir/info/blocklists && \
    test -d $dir/watch  || mkdir -p $dir/watch
COPY settings.json /var/lib/transmission-daemon/info
RUN dir="/var/lib/transmission-daemon" && \
    chown -Rh debian-transmission. $dir && \
    rm -rf /var/lib/apt/lists/* /tmp/*
COPY transmission.sh /usr/bin/

VOLUME ["/var/lib/transmission-daemon"]

EXPOSE 9091 51413/tcp 51413/udp

ENTRYPOINT ["transmission.sh"]
