var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#Timeout.ptimeout",
    "page": "Home",
    "title": "Timeout.ptimeout",
    "category": "function",
    "text": "ptimeout(f, limit; worker=1, poll=0.5, verbose=true)\n\nRun the given function f in a separate process on worker worker for a maximum time of limit, which can be a number of seconds or a Dates.Period. If the time limit is reached, the remote process will be interrupted, first by sending SIGINTs and then by sending a SIGTERM to forcibly kill the process if the interrupts are ineffective. If f completed without timing out, true is returned, otherwise false.\n\nThe keyword argument worker selects the worker by process ID from the pool of worker processes known to Julia, i.e. that which is returned by workers(). The chosen worker cannot be the current process.\n\npoll is the number of seconds to wait before rechecking whether f has finished executing on the remote worker. For long running jobs, you may want to set this higher than the default 0.5, which will poll every half second.\n\nIf verbose is true, a warning will be logged by the calling process before attempting to interrupt.\n\nwarn: Warn\nThe return value refers ONLY to whether the computation timed out. Computation of f may have terminated due to an error that\'s unrelated to an interrupt sent by ptimeout, and this will NOT be reflected in the return value.\n\n\n\n\n\n"
},

{
    "location": "index.html#Timeout.@ptimeout",
    "page": "Home",
    "title": "Timeout.@ptimeout",
    "category": "macro",
    "text": "@ptimeout worker limit expr\n\nWrap the given expression expr in a function and run it on a remote worker up to the given amount of time, limit. This macro is a thin convenience wrapper around the ptimeout function.\n\n\n\n\n\n"
},

{
    "location": "index.html#Timeout.jl-1",
    "page": "Home",
    "title": "Timeout.jl",
    "category": "section",
    "text": "This package provides a function ptimeout for running a function on a remote process for a specified amount of time, as well as a convenience macro @ptimeout that wraps this function.Note that the \"p\" prefix ptimeout comes from the fact that this is a distributed, i.e. parallel, computation, in a similar sense to pmap. In particular, this means that for it to work, there must be at least one worker process available aside from the main process.Timeout.ptimeout\nTimeout.@ptimeout"
},

]}
