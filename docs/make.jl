using Documenter, Conductor

makedocs(sitename="Conductor.jl",
         doctest = true,
         modules = [Conductor],
         pages = ["Home" => "index.md",
                  "Basics" => "basics.md",
                  "Core" => ["Primitives" => "core/primitives.md",
                             "Gates"      => "core/gates.md",
                             "Compartments" => "core/compartments.md",
                             "Networks"     => "core/networks.md",]])

deploydocs(
    repo = "github.com/wsphillips/Conductor.jl.git",
    devbranch = "main",
    push_preview=true
)
