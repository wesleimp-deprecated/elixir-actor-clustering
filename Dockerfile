FROM bitwalker/alpine-elixir-phoenix:1.11.3 as releaser

ARG ENV
ARG APP_VERSION

ENV ENV prod
ENV MIX_ENV prod

WORKDIR /app

RUN mix do local.hex --force, local.rebar --force

COPY rel/ /app/rel/
COPY config/ /app/config/
COPY mix.exs /app/
COPY mix.* /app/

RUN mix do deps.get --only prod, deps.compile

COPY . /app/

WORKDIR /app

RUN mix compile

RUN mix phx.digest

WORKDIR /app

RUN mix release
# ============================================================================ #

FROM alpine:3.12.0

RUN apk add --no-cache openssl ncurses-libs

ARG ENV
ARG APP_VERSION

ENV ENV prod
ENV MIX_ENV prod

EXPOSE 4000
ENV PORT 4000
ENV SHELL /bin/bash

WORKDIR /app

COPY --from=releaser app/rel .
COPY --from=releaser app/_build/prod/rel/cluster_user .

CMD ["bin/cluster_user", "start"]