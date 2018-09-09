# Timeout.jl

[![Proof of Concept](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)

Impose execution time limits on your Julia code.

Currently this is implemented by running code in a separate process and interrupting
the process if it runs over a specified amount of time.
This approach has a number of limitations and inconveniences.
Design discussion and suggestions are welcome in issues and pull requests.
