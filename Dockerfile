FROM ruby:3.4.1-slim-bookworm

ENV LANG="C.UTF-8"

WORKDIR /app

COPY Gemfile* ./

RUN apt update \
 && apt upgrade -y \
 && apt install -y --no-install-recommends build-essential ruby-dev ruby-nio4r ruby-psych \
 && apt install -y sqlite3 \
 && gem update --system \
 && bundle install \
 && gem clean \
 && apt-get remove -y build-essential ruby-dev ruby-nio4r ruby-psych \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY . .

RUN groupadd -r rails \
 && useradd --no-log-init -r -g rails rails
RUN chown -R rails:rails .

USER rails

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

CMD ["/bin/sh", "-c", "/app/start.sh"]
