using Documenter
using Timeout

makedocs(modules=[Timeout], clean=false, format=:html, sitename="Timeout.jl",
         pages=["Home" => "index.md"])

deploydocs(repo="github.com/ararslan/Timeout.jl.git", target="build", julia="1.0",
           deps=nothing, make=nothing)
