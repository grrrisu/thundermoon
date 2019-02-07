# ----- builder container ---
FROM bitwalker/alpine-elixir-phoenix as builder

WORKDIR /thundermoon

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
COPY config config

COPY apps apps

RUN mix do deps.get, deps.compile

WORKDIR /thundermoon/apps/thunder_phoenix/assets
RUN npm install && npm run deploy

# WORKDIR /thundermoon/apps/thunder_phoenix
# RUN mix ecto.create && mix ecto.migrate

WORKDIR /thundermoon
COPY rel rel
RUN mix release --env=prod --verbose

# ---- release container ----

FROM alpine:3.6

RUN apk upgrade --no-cache && \
    apk add --no-cache bash openssl
    # we need bash and openssl for Phoenix

EXPOSE 4000

ENV PORT=4000 \
    MIX_ENV=prod \
    REPLACE_OS_VARS=true \
    SHELL=/bin/bash

WORKDIR /thundermoon

COPY --from=builder /thundermoon/_build/prod/rel/thundermoon/releases/0.1.0/thundermoon.tar.gz .

RUN tar zxf thundermoon.tar.gz && rm thundermoon.tar.gz

#RUN chown -R root ./releases

#USER root

# WORKDIR /thundermoon/apps/thunder_phoenix ???
# RUN mix ecto.migrate ???

CMD ["/thundermoon/bin/thundermoon", "foreground"]
