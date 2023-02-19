FROM elixir:1.14.3-alpine as build

ENV MIX_ENV=prod

COPY . .

RUN mix do local.hex --force, local.rebar --force

RUN apk update && apk add --no-cache build-base

RUN mix do deps.get, compile, release

##################################################
FROM erlang:25.2.3.0-alpine

RUN mkdir -p /databases/sqlite3

ENV MIX_ENV=prod DATABASE_PATH=/databases/sqlite3/relx.db
EXPOSE 1025


RUN apk update && apk add --no-cache build-base

COPY --from=build _build/prod/rel/relx .

CMD ["./bin/relx", "start"]
