# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.4.7
FROM docker.io/library/ruby:${RUBY_VERSION}-slim

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libsqlite3-dev pkg-config sqlite3 && \
    rm -rf /var/lib/apt/lists/*

ENV BUNDLE_PATH="/usr/local/bundle"

COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install

COPY . .

RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

EXPOSE 3000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
