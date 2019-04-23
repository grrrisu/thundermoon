[![Codacy Badge](https://api.codacy.com/project/badge/Grade/fe326e4fad214b2b8612c45331301320)](https://app.codacy.com/app/adm_2/thundermoon?utm_source=github.com&utm_medium=referral&utm_content=grrrisu/thundermoon&utm_campaign=Badge_Grade_Dashboard)
[![CircleCI](https://circleci.com/gh/grrrisu/thundermoon.svg?style=svg)](https://circleci.com/gh/grrrisu/thundermoon)

# thundermoon

simulations using phoenix and elixir

![Thundermoon](/thunderbird_moon.jpg)

_image: Thunderbird Moon by Joe Wilson-Sxwaset_

## Umbrella App

- [ThunderPhoenix](apps/thunder_phoenix) webapp talking to clients via WebSockets
- [SimContainer](apps/sim) doing the actual simulations

## Docker

`docker build -t=thundermoon .`

`docker run thundermoon`
