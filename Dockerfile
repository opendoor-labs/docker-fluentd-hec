FROM fluent/fluentd:v1.1.0-debian

LABEL maintainer="Gimi Liang <zliang@splunk.com>"

# expecting fluent-plugin-splunk-hec
COPY *.gem /tmp/

RUN apt-get update \
 && apt-get install -y libjq-dev \
 && buildDeps=" \
      make gcc g++ libc-dev autoconf automake libtool libltdl-dev\
      ruby-dev \
      wget bzip2 gnupg dirmngr \
    " \
 && apt-get install -y --no-install-recommends $buildDeps \
 && update-ca-certificates \
 && gem install fluent-plugin-systemd fluent-plugin-detect-exceptions oj \
 && gem install fluent-plugin-jq -v 0.4.0 \
 && gem install /tmp/*.gem \
 && apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem
