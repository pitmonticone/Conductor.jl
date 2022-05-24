
abstract type AbstractPopulationSystem <: AbstractTimeDependentSystem end

struct PopulationSystem{S<:AbstractCompartmentSystem} <: AbstractPopulationSystem
    prototype::S
    size::UInt64
    topology #::AbstractGraph (or similar)
    iv::Num
    eqs::Vector{Equation}
    defaults::Dict
    name::Symbol
    systems::Vector{AbstractTimeDependentSystem}
    observed::Vector{Equation}
    function PopulationSystem(iv, eqs, defaults, name, systems, observed; checks = false)
        if checks
            #placeholder
        end
        new(iv, eqs, defaults, name, systems, observed)
    end
end

const Population = PopulationSystem

function Population(proto::AbstractCompartmentSystem, n, topology)

end

get_prototype(x::AbstractPopulationSystem) = getfield(x, :prototype)
get_size(x::AbstractPopulationSystem)  = getfield(x, :size)
get_topology(x::AbstractPopulationSystem) = getfield(x, :topology)

function build_toplevel!(dvs, ps, eqs, defs, pop_sys::PopulationSystem)

    return eqs, dvs, ps, defs
end

function get_eqs(x::AbstractPopulationSystem; rebuild = false)
        empty!(getfield(x, :eqs))
        union!(getfield(x, :eqs), build_toplevel(x)[1])
    return getfield(x, :eqs)
end

function get_states(x::AbstractPopulationSystem)
    collect(build_toplevel(x)[2])
end

MTK.has_ps(x::PopulationSystem) = true

function get_ps(x::AbstractPopulationSystem)
    collect(build_toplevel(x)[3])
end

function defaults(x::AbstractPopulationSystem)
    build_toplevel(x)[4]
end

function get_systems()

end

function Base.:(==)(sys1::PopulationSystem, sys2::PopulationSystem)
    sys1 === sys2 && return true
    iv1 = get_iv(sys1)
    iv2 = get_iv(sys2)
    isequal(iv1, iv2) &&
    isequal(nameof(sys1), nameof(sys2)) &&
    _eq_unordered(get_eqs(sys1), get_eqs(sys2)) &&
    _eq_unordered(get_states(sys1), get_states(sys2)) &&
    _eq_unordered(get_ps(sys1), get_ps(sys2)) &&
    all(s1 == s2 for (s1, s2) in zip(get_systems(sys1), get_systems(sys2)))
end

function Base.convert(::Type{ODESystem}, population::PopulationSystem)
    # vectorize states and parameters
    # determine the maximum vertex "in degree" for each synapse type
    
    # convert prototype system to ODESystem and flatten it
    # OR write a function that vectorizes the top level of any system
    # add +1 dim of length n to all states/parameters
    # substitute new variables into all equations
    return ODESystem(eqs, t, dvs, ps; systems = syss, defaults = defs, name = nameof(population))
end
