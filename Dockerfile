###############
# Build stage #
###############
FROM elixir:1.12-alpine AS build

RUN apk add --update --no-cache build-base git

RUN mix local.hex --force \
    && mix local.rebar --force 

COPY . .

ARG MIX_ENV=prod

RUN mix deps.get \
    && mix phx.digest \
    && mix release --path /export

####################
# Deployment Stage #
####################
FROM erlang:24-alpine

WORKDIR /app

# permissions security
RUN chown nobody:nobody /app
USER nobody:nobody

COPY --from=build --chown=nobody:nobody /export /app

CMD ["bin/wms_task", "start"]

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=2 \
    CMD nc -vz -w 2 localhost 4000 || exit 1
