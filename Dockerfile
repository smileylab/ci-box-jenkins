ARG version=latest
FROM jenkins/jenkins:${version}

USER root

ARG extra_packages=""
RUN apt -q update && DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install ${extra_packages}

ARG plugins=""
RUN if [ ! -z "${plugins}" ]; then /usr/local/bin/install-plugins.sh ${plugins}; fi

# TODO migrate to secret
ARG admin_user=admin
RUN echo ${admin_user} > /var/admin_user

# TODO migrate to secret
ARG admin_password=password
RUN echo ${admin_password} > /var/admin_password

USER jenkins

# For automated password setup
COPY scripts/security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy

ARG slave_port=50000
ENV JENKINS_SLAVE_AGENT_PORT ${slave_port}

ARG http_port=8080
ENV JENKINS_OPTS --httpPort=${http_port}

# Skip setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
