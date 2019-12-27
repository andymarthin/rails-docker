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

RUN bundle install --without development test
RUN yarn install
COPY . /application

RUN RAILS_GROUPS=assets bundle exec rake assets:precompile

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

