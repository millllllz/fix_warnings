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

FixWarnings automatically fixes the trivial warnings directly in your Elixir source code. Verify the changes, using `git diff` or with the tooling of your choice.

## Alpha Warning

I extracted this from a quickly hacked together script, which worked well for me. But don't trust blindly in the patches.

Limitations:
- You have to manually copy the log output that contains the warnings into a file
- There's a few edge-cases that are not covered yet. Check the changes before you commit

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

Clean your files so that everything is compiled from scratch:

```
mix clean
```

Run your Elixir. E.g. for a phoenix application:

```
clear # empty the console window, so we can copy the ouptut.
mix
```

Manually copy (as in Cmd+a, Cmd+c, Cmd+v) the console output that contains all the warnings into a file (Note to myself: there must be multiple better ways to achieve this).

Now run fix_warnings.

```
mix fix_warnings -f path/to/output.log
```

Enjoy

```
git diff
```

## TODOs (PRs welcome)

- There might be a few edge-cases
- Find a way so fix_warnings can tap into STDERR directly, so we don't have to mess with around copying console output to files.
- Add more warnings
- Refactor mix task
