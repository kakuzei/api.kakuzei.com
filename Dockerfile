FROM ruby:3.3.4-slim-bullseye

ENV LANG="C.UTF-8"
ENV BUILD_PACKAGES build-essential ruby-dev ruby-nio4r ruby-psych
ENV RUNTIME_PACKAGES sqlite3

WORKDIR /app

COPY Gemfile* ./

RUN apt update \
 && apt upgrade -y \
 && apt install -y --no-install-recommends ${BUILD_PACKAGES} \
 && apt install -y ${RUNTIME_PACKAGES} \
 && gem update --system \
 && bundle install \
 && gem clean \
 && apt-get remove -y ${BUILD_PACKAGES} \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY . .

RUN groupadd -r rails \
 && useradd --no-log-init -r -g rails rails
RUN chown -R rails:rails .

USER rails

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

CMD bundle exec rake kakuzei:init && bundle exec falcon serve -b http://0.0.0.0:9292
