using Ballistics
using Documenter

makedocs(;
    modules=[Ballistics],
    authors="Irene Ndindabahizi",
    repo="https://github.com/YayeIrene/Ballistics.jl/blob/{commit}{path}#L{line}",
    sitename="Ballistics.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://YayeIrene.github.io/Ballistics.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/YayeIrene/Ballistics.jl",
)
