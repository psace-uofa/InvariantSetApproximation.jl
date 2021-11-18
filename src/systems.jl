"""


"""
struct System <: AbstractSystem
	f::Function
	X::Hyperrectangle
	state_dim::Int

	function System(f::Function, X::Hyperrectangle{T,Vector{T},Vector{T}}, xdim::Int) where T
		new(f, X, xdim)
	end
end

function System(f::Function, xlb::Vector{T}, xub::Vector{T}) where T
	X = Hyperrectangle(low=xlb, high=xub)
	return System(f, X, dim(X))
end

struct UncertainSystem <: AbstractUncertainSystem
	f::Function
	X::Hyperrectangle
	W::Hyperrectangle
	state_dim::Int
	uncertainty_dim::Int

	function UncertainSystem(f::Function, X::Hyperrectangle{T,Vector{T},Vector{T}}, W::Hyperrectangle{T,Vector{T},Vector{T}}, xdim::Int, wdim::Int) where T
		new(f, X, W, xdim, wdim)
	end
end

function UncertainSystem(f::Function, xlb::Vector{T}, xub::Vector{T}, wlb::Vector{T}, wub::Vector{T}) where T
	X = Hyperrectangle(low=xlb, high=xub)
	W = Hyperrectangle(low=wlb, high=wub)
	return UncertainSystem(f, X, W, dim(X), dim(W))
end

struct ControlSystem <: AbstractControlSystem
	f::Function
	X::Hyperrectangle
	U::Hyperrectangle
	state_dim::Int
	input_dim::Int

	function ControlSystem(f::Function, X::Hyperrectangle{T,Vector{T},Vector{T}}, U::Hyperrectangle{T,Vector{T},Vector{T}}, xdim::Int, udim::Int) where T
		new(f, X, U, xdim, udim)
	end
end

function ControlSystem(f::Function, xlb::Vector{T}, xub::Vector{T}, ulb::Vector{T}, uub::Vector{T}) where T
	X = Hyperrectangle(low=xlb, high=xub)
	U = Hyperrectangle(low=ulb, high=uub)
	return ControlSystem(f, X, U, dim(X), dim(U))
end

struct UncertainControlSystem <: AbstractUncertainControlSystem
	f::Function
	X::Hyperrectangle
	U::Hyperrectangle
	W::Hyperrectangle
	state_dim::Int
	input_dim::Int
	uncertainty_dim::Int

	function UncertainControlSystem(f::Function, X::Hyperrectangle{T,Vector{T},Vector{T}}, U::Hyperrectangle{T,Vector{T},Vector{T}}, 
		W::Hyperrectangle{T,Vector{T},Vector{T}}, xdim::Int, udim::Int,wdim::Int) where T
		new(f, X, U, W, xdim, udim, wdim)
	end
end

function UncertainControlSystem(f::Function, xlb::Vector{T}, xub::Vector{T}, ulb::Vector{T}, uub::Vector{T}, wlb::Vector{T}, wub::Vector{T}) where T
	X = Hyperrectangle(low=xlb, high=xub)
	U = Hyperrectangle(low=ulb, high=uub)
	W = Hyperrectangle(low=wlb, high=wub)
	return UncertainControlSystem(f, X, U, W, dim(X), dim(U), dim(W))
end

function system(f::Function, xlb::Vector{T}, xub::Vector{T}; ulb::Union{Vector{T},Nothing}=nothing, uub::Union{Vector{T},Nothing}=nothing, wlb::Union{Vector{T},Nothing}=nothing, wub::Union{Vector{T},Nothing}=nothing) where T
	if isnothing(ulb) && isnothing(uub) && isnothing(wlb) && isnothing(wub)
		return System(f, xlb, xub)
	elseif isnothing(wlb) && isnothing(wub)
		return ControlSystem(f, xlb, xub, ulb, uub)
	elseif isnothing(ulb) && isnothing(uub)
		return UncertainSystem(f, xlb, xub, wlb, wub)
	else
		return UncertainControlSystem(f, xlb, xub, ulb, uub, wlb, wub) 
	end
end