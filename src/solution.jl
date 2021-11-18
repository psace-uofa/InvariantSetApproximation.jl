
struct Solution{T} <: AbstractSolution
	iset::Vector{Hyperrectangle{T,Vector{T},Vector{T}}}
	options::Options
end

# constructor with no options
Solution(iset::Vector{Hyperrectangle}) = Solution(iset,Options())

function save_data(iter::Int, sol::Solution)
	save("solution.jld2", "$iter", sol)
end

function load_data(name::String)
	data = load(name)
	key = collect(Base.keys(data))[1]
	iter = parse(Int,key)
	sol = data[key]
	return iter, sol.iset 
end