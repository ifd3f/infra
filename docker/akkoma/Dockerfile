FROM elixir:1.11.4-alpine

ARG PLEROMA_VER=develop
ARG UID=911
ARG GID=911
ENV MIX_ENV=prod

RUN echo "http://nl.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories \
    && apk update \
    && apk add git gcc g++ musl-dev make cmake file-dev \
    exiftool imagemagick libmagic ncurses postgresql-client ffmpeg

RUN addgroup -g ${GID} akkoma \
    && adduser -h /akkoma -s /bin/false -D -G akkoma -u ${UID} akkoma

ARG DATA=/var/lib/pleroma
RUN mkdir -p /etc/akkoma \
    && chown -R akkoma /etc/akkoma \
    && mkdir -p ${DATA}/uploads \
    && mkdir -p ${DATA}/static \
    && chown -R akkoma ${DATA}

USER akkoma
WORKDIR /akkoma

RUN git clone -b ${PLEROMA_VER} https://akkoma.dev/AkkomaGang/akkoma.git --depth 1 .

RUN echo "import Mix.Config" > config/prod.secret.exs \
    && mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get --only prod \
    && mkdir release \
    && mix release --path /akkoma

COPY ./config.exs /etc/akkoma/config.exs

RUN cd /tmp \
    && wget -O akkoma-fe.zip https://akkoma-updates.s3-website.fr-par.scw.cloud/frontend/stable/akkoma-fe.zip \
    && unzip akkoma-fe.zip \
    && mkdir -p ${DATA}/static/frontends/pleroma-fe \
    && mv dist ${DATA}/static/frontends/pleroma-fe/stable \
    && rm /tmp/akkoma-fe.zip

RUN cd /tmp \
    && wget -O admin-fe.zip https://akkoma-updates.s3-website.fr-par.scw.cloud/frontend/stable/admin-fe.zip \
    && unzip admin-fe.zip \
    && mkdir -p ${DATA}/static/frontends/admin-fe \
    && mv dist ${DATA}/static/frontends/admin-fe/stable \
    && rm /tmp/admin-fe.zip

EXPOSE 4000

ENTRYPOINT ["/akkoma/docker-entrypoint.sh"]
