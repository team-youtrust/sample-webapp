FROM ruby:3.1.3

ENV RAILS_ENV development
ENV NODE_ENV development

EXPOSE 3000

WORKDIR /app

RUN bundle config set path 'vendor/bundle'

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && \
    apt-get install -y \
        build-essential \
        nodejs \
        yarn && \
    rm -rf /var/lib/apt/lists/*

COPY . /app
