FROM ruby:3.2-alpine

USER root

ENV APP_ROOT /app
ENV PORT 9292
ENV BUNDLE_PATH /bundle

RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT

COPY ./Gemfile $APP_ROOT
COPY ./Gemfile.lock $APP_ROOT

RUN apk add --update --no-cache imagemagick curl-dev font-noto \
  && apk add --update --no-cache --virtual=build-dependencies alpine-sdk \
  && bundle install -j$(nproc) \
  && apk del build-dependencies

ADD . $APP_ROOT

EXPOSE $PORT
CMD ["bundle", "exec", "puma"]
