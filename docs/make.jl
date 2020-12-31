using CropPlanner
using Documenter

makedocs(;
    modules=[CropPlanner],
    authors="Maxime Rivest <mrive052@gmail.com> and contributors",
    repo="https://github.com/MaximeRivest/CropPlanner.jl/blob/{commit}{path}#L{line}",
    sitename="CropPlanner.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://MaximeRivest.github.io/CropPlanner.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/MaximeRivest/CropPlanner.jl",
)
