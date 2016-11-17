FROM ubuntu:14.04
MAINTAINER docker@ipepe.pl

# install essential locales packages
RUN apt-get update && apt-get install -y locales && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN echo 'LANG="en_US.UTF-8"' > /etc/default/locale
RUN echo 'LANGUAGE="en_US:en"' >> /etc/default/locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

# wyciszenie apt-get
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# konfiguracja uzytkownika webapp
RUN groupadd -g 1000 webapp
RUN useradd -m -s /bin/bash -g webapp -u 1000 webapp

# instalacja nodejs
RUN apt-get update && apt-get install -y git make gcc g++ nodejs npm openssl libssl-dev curl libpq-dev cron libreadline-dev imagemagick
RUN ln -s /usr/bin/nodejs /usr/bin/node

# instalacja i konfiguracja Ruby
RUN su - webapp -c "git clone https://github.com/sstephenson/rbenv.git /home/webapp/.rbenv"
RUN echo "export PATH=/home/webapp/.rbenv/bin:/home/webapp/.rbenv/shims:${PATH}" | cat - /home/webapp/.bashrc > /tmp/out && mv /tmp/out /home/webapp/.bashrc
RUN echo "export RBENV_ROOT=/home/webapp/.rbenv" | cat - /home/webapp/.bashrc > /tmp/out && mv /tmp/out /home/webapp/.bashrc
RUN su - webapp -c "git clone https://github.com/sstephenson/ruby-build.git /home/webapp/.rbenv/plugins/ruby-build"
RUN su - webapp -c "rbenv install 2.3.1"
RUN su - webapp -c "rbenv global 2.3.1"
RUN su - webapp -c "rbenv rehash"
RUN su - webapp -c "gem install bundler"

RUN apt-get install -y libsqlite3-dev

# instalacja narzedzi do postgresql
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN apt-get update && apt-get install -y wget nano htop
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && apt-get install -y postgresql-client-9.4

# instalacja serwera ssh
RUN apt-get install -y openssh-server nginx
RUN su - webapp -c "mkdir -p /home/webapp/.ssh"
COPY ./authorized_keys /home/webapp/.ssh/
RUN chown webapp:webapp /home/webapp/.ssh/authorized_keys && chmod 600 /home/webapp/.ssh/authorized_keys
RUN mkdir /var/run/sshd
RUN chmod 0755 /var/run/sshd

# dodanie usera webapp do sudo
RUN echo 'webapp ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
WORKDIR /home/webapp

CMD ["/usr/sbin/sshd", "-D"]
