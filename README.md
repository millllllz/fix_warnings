# FixWarnings

Automatically fixes compiler warnings in your Elixir project.

Does that look familiar?

```
Compiling 5 files (.ex)
warning: variable "params" is unused
  lib/controller.ex:24

... 500 lines more...

warning: variable "curr_line" is unused
  lib/foo.ex:31
```

FixWarnings automatically fixes the trivial warnings directly in your Elixir source code. It removes unused aliases and adds a `_` prefix to unused variables with.

## Alpha Warning

I extracted this from a quickly hacked together script, which worked well for me. But don't trust this blindly yet, verify with git diff first.

## Guide

Add `fix_warnings` to your mix.exs.

```elixir
def deps do
  [
    {:fix_warnings, "~> 0.1.0", only: :dev}
  ]
end
```

Install dependency

```
mix deps.get
```

Run fix_warnings:
```
mix fix_warnings
```

Or run with explicitly captured logs:
```
mix compile --force &> path/to/output.log

mix fix_warnings -f path/to/output.log
# or mix fix_warnings --file=path/to/output.log
```

Enjoy

```
git diff
```

## TODOs (PRs welcome)

- There might be a few edge-cases
- Add more warnings
- Refactor mix task
- Does not seem to capture warnings in `.exs` files
- Add support for `preview` flag
  - this should be the default, so maybe add support for `force` flag?
- Add diffing output