# Sim

Simulation container to handle user input and simulation calculations through an event queue and broadcast the changes to a list of subscribers. All messages are processed async, but the event queue will make sure that only one event after an other is processed and therefore the consistency of the simulation ensured.

## Examples

- [simple user input](lib/example/handler.ex)
- [simple counter simulation](lib/example/counter)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sim` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sim, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/sim](https://hexdocs.pm/sim).
