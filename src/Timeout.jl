__precompile__()

module Timeout

using Compat.Distributed
using Compat.Dates

export ptimeout, @ptimeout

if isdefined(Base, :_UVError)
    using Base: _UVError
else
    const _UVError = Base.UVError
end

"""
    ptimeout(f, limit; worker=1, poll=0.5, verbose=true)

Run the given function `f` in a separate process on worker `worker` for a maximum time
of `limit`, which can be a number of seconds or a `Dates.Period`. If the time limit is
reached, the remote process will be interrupted, first by sending SIGINTs and then by
sending a SIGTERM to forcibly kill the process if the interrupts are ineffective. If `f`
completed without timing out, `true` is returned, otherwise `false`.

The keyword argument `worker` selects the worker by process ID from the pool of worker
processes known to Julia, i.e. that which is returned by `workers()`. The chosen worker
cannot be the current process.

`poll` is the number of seconds to wait before rechecking whether `f` has finished
executing on the remote worker. For long running jobs, you may want to set this higher
than the default 0.5, which will poll every half second.

If `verbose` is `true`, a warning will be logged by the calling process before attempting
to interrupt.

!!! warn
    The return value refers ONLY to whether the computation timed out. Computation of
    `f` may have terminated due to an error that's unrelated to an interrupt sent by
    `ptimeout`, and this will NOT be reflected in the return value.
"""
function ptimeout(f::Function, secs::Real; worker=1, poll=0.5, verbose=true)
    nprocs() > 1 || throw(ArgumentError("No worker processes available"))
    worker in workers() || throw(ArgumentError("Unknown worker process ID: $worker"))
    worker == myid() && throw(ArgumentError("Can't run ptimeout on the current process"))
    poll > 0 || throw(ArgumentError("Can't poll every $poll seconds"))

    # Start by getting the OS process ID for the worker so that we have something to
    # forcibly kill if need be
    ospid = remotecall_fetch(()->ccall(:getpid, Cint, ()), worker)

    # Run the function on the given worker, with a channel for communicating with the
    # process so that checking isready won't block
    channel = Channel(1)
    start = time()
    @async put!(channel, remotecall_fetch(f, worker))
    while time() - start < secs && !isready(channel)
        sleep(poll)
    end
    isready(channel) && return true
    verbose && @warn "Time limit for computation exceeded. Interrupting..."
    patience = 10
    while !isready(channel) && (patience -= 1) > 0
        interrupt(worker)
    end
    # If our interrupts didn't work, forcibly kill the process
    if !isready(channel)
        rc = ccall(:uv_kill, Cint, (Cint, Cint), ospid, Base.SIGTERM)
        rc == 0 || throw(_UVError("kill", rc))
    end
    close(channel)
    false
end

ptimeout(f::Function, time::Period; kwargs...) =
    ptimeout(f, Dates.value(convert(Second, time)); kwargs...)

"""
    @ptimeout worker limit expr

Wrap the given expression `expr` in a function and run it on a remote worker up to the
given amount of time, `limit`. This macro is a thin convenience wrapper around the
[`ptimeout`](@ref) function.
"""
macro ptimeout(worker, limit, expr)
    :(ptimeout(()->$expr, $limit, worker=$worker))
end

end # module
