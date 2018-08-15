FROM openjdk:8
#FROM ubuntu:16.04
MAINTAINER Marcin Kasiñski <marcin.kasinski@gmail.com> 

ENV ZOOKEEPER_MIRROR=http://ftp.man.poznan.pl/apache/zookeeper/zookeeper-3.4.13/ \
	ZOOKEEPER_VERSION=zookeeper-3.4.13 \
	ZOOKEEPER_NODES="server.1=mainserver:2888:3888;server.4=mainserver2:2888:3888;server.3=mainserver3:2888:3888" \
	ZOOKEEPER_DATADIR="/data/zookeeper" \
	ZOOKEEPER_LOGDIR="/datalog/zookeeper" \
	CONFIG="/opt/zookeeper/conf/zoo.cfg"

RUN mkdir /usr/src/myapp 

ADD libs.sh /usr/src/myapp/libs.sh
RUN sed -i -e 's/\r//g' /usr/src/myapp/libs.sh
ADD start.sh /usr/src/myapp/start.sh
RUN sed -i -e 's/\r//g' /usr/src/myapp/start.sh

ADD conf/zoo.cfg /usr/src/myapp/conf/zoo.cfg


RUN curl -o /opt/${ZOOKEEPER_VERSION}.tar.gz ${ZOOKEEPER_MIRROR}${ZOOKEEPER_VERSION}.tar.gz && \
	tar -zxf /opt/${ZOOKEEPER_VERSION}.tar.gz -C /opt && \
	rm /opt/${ZOOKEEPER_VERSION}.tar.gz && ln -s /opt/${ZOOKEEPER_VERSION} /opt/zookeeper && \
	cp /usr/src/myapp/conf/zoo.cfg $CONFIG

WORKDIR /opt/zookeeper

EXPOSE 2181

RUN chmod +x /usr/src/myapp/start.sh
ENTRYPOINT [ "/usr/src/myapp/start.sh" ]