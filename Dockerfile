FROM ruby:2.2
MAINTAINER Thomas HUMMEL <thummel@codde.fr>
ENV REFRESHED_AT 2015-09-15

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install --without test development

COPY . /usr/src/app

RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Precompile assets
ENV SECRET_KEY_BASE 12332e1d4e0f342613b18645a7db96b41ba599ebf323cda09950f3507c67ad8d32e0946751c2070351eb5f884f272acb6b432a89deedd23389675c57f446ef35
RUN RAILS_ENV=production bundle exec rake assets:precompile

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
