ARG version=latest
FROM jenkins/jenkins:${version}

USER root
ARG extra_packages=""
RUN apt -q update && DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install ${extra_packages}
USER jenkins

ARG slave_port=50000
ENV JENKINS_SLAVE_AGENT_PORT ${slave_port}

ARG http_port=8080
ENV JENKINS_OPTS --httpPort=${http_port}
