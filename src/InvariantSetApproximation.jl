module InvariantSetApproximation

# imports
using Graphs
using SpatialIndexing
using LazySets

# constants to avoid using long names
const SI = SpatialIndexing
const LS = LazySets

include("abstracts.jl")
include("systems.jl")
include("options.jl")
include("solvers.jl")
include("hyperrectangle.jl")
include("core.jl")
include("solution.jl")

# exports to be used outside the module
export system, Options, computeISet, ConvexHullArray

end # module
