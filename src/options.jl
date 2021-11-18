
"""
	Options <: AbstractOptions

Type that wraps a dictionary used for options

### Fields


"""

struct Options <: AbstractOptions
	dict::Dict{Symbol, Any}
	Options(args::Pair{Symbol,Any}...) = new(Dict{Symbol,Any}(args))
	Options(args::Dict{Symbol,<:Any}) = new(args)
end


"""
	keys

"""

keys(opt::Options) = keys(opt.dict)


"""
	values

"""
values(opt::Options) = values(opt.dict)