FROM ruby:2.6.5
MAINTAINER mr.andymarthin@gmail.com
LABEL version="1.0.2"

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
# Add NodeJS to sources list
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends build-essential postgresql-client curl dirmngr apt-transport-https lsb-release ca-certificates nodejs yarn && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && truncate -s 0 /var/log/*log

RUN mkdir /application
WORKDIR /application

COPY Gemfile /application/Gemfile
COPY Gemfile.lock /application/Gemfile.lock
COPY package.json /application/package.json
COPY yarn.lock /application/yarn.lock

RUN bundle install
COPY . /application
RUN yarn install

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

