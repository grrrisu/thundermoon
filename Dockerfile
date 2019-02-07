# official elixir image
FROM elixir:1.7.4

ENV MIX_ENV=prod

# install NodeJS and NPM
RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install nodejs

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# elixir dependencies
RUN mix local.hex --force --if-missing && \
    mix local.rebar --force && \
    mix deps.get && mix compile

EXPOSE 4000

# prepare assets

WORKDIR /app/apps/thunder_phoenix/assets

RUN npm install && npm run deploy

WORKDIR /app/apps/thunder_phoenix

# RUN mix ecto.create && mix ecto.migrate
CMD mix phx.server
