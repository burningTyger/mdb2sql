# Docker image definition for running the mdbtools utility

FROM ruby:alpine3.6

RUN apk --no-cache add wget ca-certificates \
    autoconf \
    automake \
    build-base \
    glib \
    glib-dev \
    libc-dev \
    libtool \
    linux-headers \
    txt2man man \
    libc6-compat \
    p7zip && \
    cd /tmp && \
  	wget "https://github.com/brianb/mdbtools/archive/master.zip" && \
    unzip master.zip && rm master.zip && \
    cd mdbtools-master && \
    autoreconf -i -f && \
    ./configure && make && make install && \
    cd /tmp && \
    rm -rf mdbtools-master && \
    mkdir /app
ENV APP /app
EXPOSE 9292

ADD mdb2sql.sh $APP

WORKDIR $APP
CMD bundle exec puma

ADD Gemfile* $APP/

RUN bundle install  --without development test && \
    apk del autoconf automake build-base glib-dev libc-dev linux-headers libc6-compat
ADD . $APP
