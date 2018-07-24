FROM ruby:2.5.1-alpine3.7

RUN apk add --no-cache -t build-dependencies \
    build-base \
    postgresql-dev \
  && apk add --no-cache \
    git \
    tzdata \
    nodejs \
    yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./

ENV RAILS_ENV production
ENV RACK_ENV production
ENV NODE_ENV production

RUN gem install bundler && bundle install --without development test

COPY . ./

RUN SECRET_KEY_BASE=docker ./bin/rake assets:precompile && ./bin/yarn cache clean
