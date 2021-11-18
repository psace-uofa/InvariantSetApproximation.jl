
function face_sampling(n::Int,dim::Int, tol::T) where T

	X1 = [collect(range(-tol,stop=tol, length=n)) for i in 1:dim]
	X = Iterators.product(X1 ...)
	sp = vec(collect.(X))
	sp = [sp[i] for i in 1:Int(length(sp)) if any(sp[i] .== tol) || any(sp[i] .== -tol) || sp[i] == zeros(dim)]
	return unique(sp)

end

function uniform_sampling(n::Int,dim::Int)
	X1 = [collect(range(-1,stop=1, length=n)) for i in 1:dim]
	X = Iterators.product(X1 ...)
	sp = vec(collect.(X))::Vector{Vector{Float64}}
	return unique(sp)
end

# Samples only the center point
function center_sampling(n::Int, dim::Int)
	return [zeros(dim)]
end

function sampleX(sampling_type::Symbol, ns::Int, dim::Int, T)

	if sampling_type == :uniform
		return uniform_sampling(ns, dim)
	end

	if sampling_type == :face
		return face_sampling(ns, dim, convert(T,0.98))
	end

	if sampling_type == :random
		return LHC_sampling(ns, dim)
	end

	if sampling_type == :center
		return center_sampling(ns, dim)
	end
	
	error("Unknown sampling method type. Please leave default for uniform sampling or select either uniform or face or random.")
end

# Auxiliary function for sampling inputs and disturbances
function sampleUW(n::Int, dim::Int, ub::Vector{T}, lb::Vector{T}) where T
	X1 = [collect(range(lb[i],stop=ub[i], length=n)) for i in 1:dim]
	X = Iterators.product(X1 ...)
	sp = vec(collect.(X))::Vector{Vector{T}}
	return unique(sp)
end		

function sample_points!(y::Vector{Vector{T}}, bx::AbstractHyperrectangle, Xsp::Vector{Vector{T}}) where T
	@simd for i in 1:length(Xsp)
		@inbounds y[i] .= Xsp[i] .* radius_hyperrectangle(bx) .+ LS.center(bx) # [sp[i][1]*box.radius[1]+box.center[1], sp[i][2]*box.radius[2]+box.center[2]]
	end
end


