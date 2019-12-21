FROM openjdk:9
#FROM ubuntu:16.04
MAINTAINER Marcin Kasi�ski <marcin.kasinski@gmail.com> 

ENV ZOOKEEPER_MIRROR=http://ftp.man.poznan.pl/apache/zookeeper/zookeeper-3.5.6/ \
	ZOOKEEPER_VERSION=apache-zookeeper-3.5.6 \
	ZOOKEEPER_NODES="server.1=mainserver:2888:3888;server.4=mainserver2:2888:3888;server.3=mainserver3:2888:3888" \
	ZOOKEEPER_DATADIR="/data/zookeeper" \
	ZOOKEEPER_LOGDIR="/datalog/zookeeper" \
	CONFIG="/opt/zookeeper/conf/zoo.cfg" \
	PROMETHEUS_JMX_AGENT_MIRROR="https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/" \
	PROMETHEUS_JMX_AGENT_VERSION="0.3.1" \
	PROMETHEUS_JMX_AGENT_PORT="8080"
	
ENV SERVER_JVMFLAGS=-javaagent:/opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent.jar=${PROMETHEUS_JMX_AGENT_PORT}:/opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent_zookeeper.yaml
	
RUN mkdir /usr/src/myapp && mkdir /opt/jmx_prometheus_javaagent

ADD jmx_prometheus_javaagent/jmx_prometheus_javaagent_zookeeper.yaml /opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent_zookeeper.yaml

ADD libs.sh /usr/src/myapp/libs.sh
RUN sed -i -e 's/\r//g' /usr/src/myapp/libs.sh
ADD start.sh /usr/src/myapp/start.sh
RUN sed -i -e 's/\r//g' /usr/src/myapp/start.sh

ADD conf/zoo.cfg /usr/src/myapp/conf/zoo.cfg

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y krb5-user tcpdump && curl -o /opt/${ZOOKEEPER_VERSION}-bin.tar.gz ${ZOOKEEPER_MIRROR}${ZOOKEEPER_VERSION}-bin.tar.gz && \
	tar -zxf /opt/${ZOOKEEPER_VERSION}-bin.tar.gz -C /opt && \
	rm /opt/${ZOOKEEPER_VERSION}-bin.tar.gz && ln -s /opt/${ZOOKEEPER_VERSION}-bin /opt/zookeeper && \
	cp /usr/src/myapp/conf/zoo.cfg $CONFIG && \
	curl -o /opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent-${PROMETHEUS_JMX_AGENT_VERSION}.jar ${PROMETHEUS_JMX_AGENT_MIRROR}${PROMETHEUS_JMX_AGENT_VERSION}/jmx_prometheus_javaagent-${PROMETHEUS_JMX_AGENT_VERSION}.jar && \
	ln -s /opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent-${PROMETHEUS_JMX_AGENT_VERSION}.jar /opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent.jar && \
	sed -i -e 's/\r//g' /opt/jmx_prometheus_javaagent/jmx_prometheus_javaagent_zookeeper.yaml

WORKDIR /opt/zookeeper

EXPOSE 2181 8080

RUN chmod +x /usr/src/myapp/start.sh
ENTRYPOINT [ "/usr/src/myapp/start.sh" ]