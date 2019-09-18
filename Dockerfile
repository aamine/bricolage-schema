FROM ruby:2.5.5-slim
MAINTAINER Minero Aoki <minero-aoki@cookpad.com>

RUN mkdir -p /log
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libpq5 postgresql-client

COPY Gemfile /tmp/Gemfile
COPY Gemfile.lock /tmp/Gemfile.lock
RUN cd /tmp && bundle install -j4 --deployment --without 'development test cap'

WORKDIR /app
COPY . /app
RUN mv database.yml.docker database.yml
RUN cp -a /tmp/vendor /app/

CMD ["bundle", "exec", "ridgepole", "-f", "Schemafile", "-c", "database.yml", "--merge", "--dry-run"]
