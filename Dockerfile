ARG version=latest
FROM jenkins/jenkins:${version}

USER root

ENV DEBIAN_FRONTEND=noninteractive

ARG extra_packages=""
RUN apt -q update && apt-get -q -y upgrade
RUN case ${extra_packages} in *repo*) apt-get -q -y install curl && curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo && chmod a+x /usr/bin/repo;; esac
RUN case ${extra_packages} in *repo*) apt-get -q -y install $(echo ${extra_packages} | sed 's,repo\s*,,g');; *) apt-get -q -y install ${extra_packages};; esac

ARG plugins=""
RUN if [ ! -z "${plugins}" ]; then /usr/local/bin/install-plugins.sh ${plugins}; fi

USER jenkins

# For automated jnlp setup
COPY scripts/tcp-slave-agent-port.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy

ARG agent_port=50000
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}

ARG http_port=8080
ENV JENKINS_OPTS --httpPort=${http_port}

# Skip setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
