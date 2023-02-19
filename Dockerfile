FROM elixir:1.14.3-slim as build

ENV MIX_ENV=prod

COPY . .

RUN mix do local.hex --force, local.rebar --force

RUN apt update && apt install libsqlite3-dev build-essential -y

RUN mix do deps.get, deps.compile, release

##################################################
FROM erlang:25.2.3.0-slim

RUN mkdir -p /databases/sqlite3

ENV MIX_ENV=prod DATABASE_PATH=/databases/sqlite3/relx.db

EXPOSE 1025

RUN apt update && apt install build-essential sqlite3 -y

COPY --from=build _build/prod/rel/relx .

CMD ["./bin/relx", "start"]
