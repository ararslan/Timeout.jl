# Timeout.jl

This package provides a function `ptimeout` for running a function on a remote process
for a specified amount of time, as well as a convenience macro `@ptimeout` that wraps
this function.

Note that the "p" prefix `ptimeout` comes from the fact that this is a distributed,
i.e. parallel, computation, in a similar sense to `pmap`. In particular, this means that
for it to work, there must be at least one worker process available aside from the main
process.

```@docs
Timeout.ptimeout
Timeout.@ptimeout
```
