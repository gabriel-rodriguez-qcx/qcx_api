FROM ruby:2.7.2-alpine3.12

RUN apk update && \
    apk add \
      bash \
      build-base \
      git \
      libxml2-dev \
      libxslt-dev \
      mariadb-dev \
      ruby-dev \
      tzdata

ENV BUNDLE_PATH /usr/local/bundle


COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle config set path $BUNDLE_PATH
RUN bundle check || bundle install


COPY . .

WORKDIR /app

EXPOSE 3000
CMD ["rails", "server", "-p ", "3000", "-b", "0.0.0.0"]
