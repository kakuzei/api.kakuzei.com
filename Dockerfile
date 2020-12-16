FROM ruby:2.7.2-alpine

ENV LANG="C.UTF-8"
ENV BUILD_PACKAGES bash build-base curl-dev sqlite-dev zlib-dev
ENV RUNTIME_PACKAGES sqlite sqlite-libs

WORKDIR /app

COPY Gemfile* ./

RUN apk update \
 && apk upgrade \
 && apk add $BUILD_PACKAGES \
 && apk add $RUNTIME_PACKAGES \
 && rm -rf /var/cache/apk/* \
 && gem update bundler \
 && bundle install \
 && gem cleanup \
 && rm -rf /usr/lib/ruby/gems/*/cache/* \
 && apk del $BUILD_PACKAGES \
 && mkdir -p tmp/pids

RUN addgroup -g 1000 rails \
 && adduser -S -u 1000 -g rails -s /bin/bash rails

COPY . .

RUN chown -R rails:rails .

USER rails

CMD bundle exec rake kakuzei:init && bundle exec puma
