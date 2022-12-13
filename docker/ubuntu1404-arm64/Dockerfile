# To build the dev environment.
# docker buildx build --platform linux/arm64/v8 -t rapid7/msf-ubuntu1404-arm64-omnibus .
FROM ubuntu:trusty@sha256:5ed16aa332467821529d451800e6fe599d83e30471e91b096752f8696d9bf6e9
MAINTAINER Rapid7 Release Engineering <r7_re@rapid7.com>

RUN rm -fr /var/lib/apt/lists && \
    apt-get update && \
    apt-get install -y \
        curl \
        binutils-doc \
        flex \
        git \
        ruby ruby-dev \
        ccache \
        fakeroot \
        libreadline-dev \
        libcurl4-openssl-dev \
        libexpat1-dev \
        libicu-dev \
        reprepro \
        sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git config --global user.email "packager@example.com" && \
    git config --global user.name "Omnibus Packager"

ENV JENKINS_HOME /home/jenkins
RUN useradd -d "$JENKINS_HOME" -u 1001 -m -s /bin/sh jenkins

RUN mkdir -p "$JENKINS_HOME" && \
    cp ~/.gitconfig "$JENKINS_HOME" && \
    chown -R jenkins "$JENKINS_HOME" && \
    mkdir -p /var/cache/omnibus && \
    mkdir -p /opt/metasploit-framework && \
    chown jenkins /var/cache/omnibus && \
    chown jenkins /opt/metasploit-framework
RUN mkdir -p /etc/sudoers.d
RUN echo "jenkins    ALL=NOPASSWD: ALL" > /etc/sudoers.d/jenkins
RUN chmod 440 /etc/sudoers.d/jenkins

RUN su jenkins -c 'command curl -sSL https://rvm.io/mpapis.asc | gpg --import - '
RUN su jenkins -c 'command curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -'
RUN su jenkins -c 'curl -L -sSL --insecure https://get.rvm.io | bash -s stable'

RUN su jenkins -c "/bin/bash -l -c 'rvm requirements'"
RUN su jenkins -c "/bin/bash -l -c 'rvm install 2.6.5'"
RUN su jenkins -c "/bin/bash -l -c 'gem install bundler -v 2.1.4 --no-document'"

# pre-load the omnibus dependencies
RUN su jenkins -c "/bin/bash -l -c 'cd ~/ && git clone https://github.com/rapid7/metasploit-omnibus.git && \
        cd ~/metasploit-omnibus && bundle install --binstubs && cd ~/ && rm -fr metasploit-omnibus'"
