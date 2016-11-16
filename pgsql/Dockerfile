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

RUN apt-get install -y curl \
	&& curl -o /usr/local/bin/gosu -SL 'https://github.com/tianon/gosu/releases/download/1.1/gosu' \
	&& chmod +x /usr/local/bin/gosu \
	&& apt-get purge -y --auto-remove curl


RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/pgdg.list

RUN apt-get install --yes wget

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get update

RUN apt-get install -y postgresql-9.4 postgresql-contrib-9.4

RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql
RUN mkdir -p /var/lib/postgresql/data && chown -R postgres /var/lib/postgresql
ENV PATH /usr/lib/postgresql/9.4/bin:$PATH
ENV PGDATA /var/lib/postgresql/data
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 5432
CMD ["postgres"]
