
"""
	
"""

struct ISolver <: AbstractSolver
	options::Options

	function ISolver(op::Options)
		new(op)
	end
end

ISolver(op::Pair{Symbol,<:Any}...) =  ISolver(Options(op))

init(S::AbstractSystem, O::Options) = init!(S, O)

function init!(S::AbstractSystem, O::Options)
	solver = ISolver(O)
	return solver
end

function preprocess(S::AbstractSystem, O::Options)
	type = eltype(S.X)

	dim_x = state_dim(S)

	solver = init(S, O)
	
	max_step = solver.options.dict[:max_step]::Int
	#TODO implement inerval arithmetic to avoid sampling
	Xsp = sampleX(solver.options.dict[:Xsampletype],solver.options.dict[:nXsamples],dim_x, type)

	if has_input(S)
		dim_u = input_dim(S)
		Usp = sampleUW(solver.options.dict[:nUsamples], dim_u, low(S.U), high(S.U))
	else
		dim_u = 1
		Usp = [[0.0]]
	end

	if has_uncertainty(S)
		dim_w = uncertainty_dim(S)
		Wsp = sampleUW(solver.options.dict[:nWsamples], dim_w, low(S.W), high(S.W))
	else
		dim_w = 1
		Wsp = [[0.0]]
	end
	
	iset = split(state_set(S),ones(Int,dim_x))
	
	return dim_x, max_step, Xsp, Usp, Wsp, iset
end

function computeISet(S::AbstractSystem, O::Options)
	dim_x, max_step, Xsp, Usp, Wsp, iset = preprocess(S, O)
	i = 0
	@inbounds while i < max_step
		println("Iteration: $i")
		number_of_cells = length(iset)
		println("Number of cells: $number_of_cells")
		println("")

		# select all cells to divide
		to_divide = collect(1:length(iset))
		# divide all cells
		subdivide_cells!(iset, to_divide, dim_x, i%dim_x + 1)
		# uncertainty set limit
		@inbounds for w in Wsp
			# create symbolic image (digraph)
			G = create_symbolic_image(iset, S, Xsp, Usp, w)
			# select nonleaving cells
			nlc_w = analyze_graph(G)
			# find intersection
			nlc = intersect(collect(1:length(iset)),nlc_w)
			# select nonleaving cells and discard leaving cells
			iset = iset[nlc]
		end
		# increment i
		i += 1
	end
	return Solution(iset, O)
end




