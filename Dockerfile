FROM ruby:2.6.5-alpine

ENV RAILS_ENV production

LABEL version="1.0.5"

# RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apk add --no-cache --update build-base \
                                linux-headers \
                                git \
                                postgresql-dev \
                                nodejs \
                                tzdata\
                                yarn\
                                imagemagick
# RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends build-essential postgresql-client curl dirmngr apt-transport-https lsb-release ca-certificates nodejs yarn && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && truncate -s 0 /var/log/*log

RUN mkdir /application
WORKDIR /application

COPY Gemfile* /application/
COPY package.json /application/
COPY yarn.lock /application/

RUN gem install bundler -v 2.1.4 && \
  bundle install --no-cache --without development test && \
  rm -rf /usr/local/bundle/bundler/gems/*/.git \
  /usr/local/bundle/cache/
RUN yarn install
COPY . /application

RUN RAILS_ENV=production rails assets:precompile && \
  rm -rf node_modules tmp/* log/*

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

