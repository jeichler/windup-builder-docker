FROM fedora:27

VOLUME /var/git/repo
VOLUME /var/m2

ENV LOCAL_USER rhamt
ENV MVN_COMMAND 'mvn clean install -DskipTests -Dmaven.repo.local=/var/m2/repository -U'

RUN dnf upgrade -y \
    && dnf install -y java-1.8.0-openjdk-devel-1.8.0.144 java-1.8.0-openjdk-headless-1.8.0.144 \
#    && dnf install -y java-1.8.0-openjdk-devel java-1.8.0-openjdk-headless \ use when wildfly maven plugin 1.2.2 is released: https://issues.jboss.org/browse/WFMP-94
# this is why we use F27 as well for now
    && dnf install -y vim bzip2 unzip zip wget python gcc-c++ \
    && dnf install -y nodejs git \
    && dnf install -y maven \
    && wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo \
    && dnf install -y yarn \
    && npm install -g phantomjs-prebuilt --unsafe-perm \
    && npm install -g bower \
    && adduser $LOCAL_USER

USER $LOCAL_USER

COPY settings.xml /var/m2/settings.xml

WORKDIR /var/git/repo
ENTRYPOINT $MVN_COMMAND
