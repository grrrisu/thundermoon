[![Codacy Badge](https://api.codacy.com/project/badge/Grade/fe326e4fad214b2b8612c45331301320)](https://app.codacy.com/app/adm_2/thundermoon?utm_source=github.com&utm_medium=referral&utm_content=grrrisu/thundermoon&utm_campaign=Badge_Grade_Dashboard)
[![CircleCI](https://circleci.com/gh/grrrisu/thundermoon.svg?style=svg)](https://circleci.com/gh/grrrisu/thundermoon)

# thundermoon

simulations using phoenix and elixir

![Thundermoon](/thunderbird_moon.jpg)

_image: Thunderbird Moon by Joe Wilson-Sxwaset_

## Umbrella App

- [ThunderPhoenix](apps/thunder_phoenix) webapp talking to clients via WebSockets
- [SimContainer](apps/sim) doing the actual simulations

## Deploy

`mix release`

```
To start the release you have built, you can use one of the following tasks:

    # start a shell, like 'iex -S mix'
    > _build/dev/rel/thundermoon/bin/thundermoon console

    # start in the foreground, like 'mix run --no-halt'
    > _build/dev/rel/thundermoon/bin/thundermoon foreground

    # start in the background, must be stopped with the 'stop' command
    > _build/dev/rel/thundermoon/bin/thundermoon start

If you started a release elsewhere, and wish to connect to it:

    # connects a local shell to the running node
    > _build/dev/rel/thundermoon/bin/thundermoon remote_console

    # connects directly to the running node's console
    > _build/dev/rel/thundermoon/bin/thundermoon attach

For a complete listing of commands and their use:

    > _build/dev/rel/thundermoon/bin/thundermoon help
```
