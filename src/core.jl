
function subdivide_cells!(ISet, to_divide::Vector{Int}, dim::Int, direction::Int)
	n = length(to_divide)
	l = length(ISet) + 1
	resize!(ISet,n+l-1)
	xd = ones(Int,dim)
	xd[direction] = 2

	@inbounds for i in to_divide
		x = split(ISet[i], xd)
		ISet[i] = x[1]
		ISet[l] = x[2]
		l += 1
	end
end

function nextstates!(y::Vector{Vector{T}}, f::Function, x::Vector{Vector{T}}, Usp::Vector{Vector{T}}, w::Vector{T}) where T
	lx = length(x)
	lu = length(Usp)
    @inbounds for i in 1:lx
        @inbounds for j in 1:lu
        	y[i+lx*(j-1)] .= f(x[i],Usp[j], w)
        end
    end
end

function create_RTree(ISet::Vector{Hyperrectangle{T, Array{T,1}, Array{T,1}}}, dim::Int) where T
	tree = RTree{T, dim}(Int)
	@inbounds for (id, cell) in enumerate(ISet)
		insert!(tree, SI.Rect(Tuple(low(cell)),Tuple(high(cell))), id)
	end
	return tree
end

function find_hits(pts::Vector{Vector{T}}, tree::RTree) where T
	hits = Vector{Int}()
	some_empty = false
	@inbounds for (id, pt) in enumerate(pts)
		ptt = SI.Point((pt...,))
		hit = collect(intersects_with(tree, SI.Rect(ptt)))
		if !isempty(hit) && !(hit[1].val in hits)
			push!(hits,hit[1].val)
		end
		if isempty(hit) && !some_empty
			some_empty = true
		end
	end
	return some_empty, sort!(hits)
end

function create_symbolic_image(iset, S::AbstractSystem, Xsp::Vector{Vector{T}}, Usp::Vector{Vector{T}}, w::Vector{T}) where T
	tree = create_RTree(iset, state_dim(S))
	E = edge_list(iset, S, Xsp, Usp, w, tree)
	return create_graph(E, length(iset))
end

function edge_list(ISet, S::AbstractSystem, Xsp::Vector{Vector{T}}, Usp::Vector{Vector{T}}, w::Vector{T}, tree) where T
	xdim = state_dim(S)
	E = [sizehint!(Vector{Int}(),length(Xsp)) for _ in 1:length(ISet)]
	y = [Vector{Float64}(undef,xdim) for _ in 1:length(Xsp)*length(Usp)]
	x = [Vector{Float64}(undef,xdim) for _ in 1:length(Xsp)]
	edge_list!(E,x,y,S.f,Xsp,Usp,w,ISet,tree)
	return E
end

function edge_list!(E::Vector{Vector{Int}}, x::Vector{Vector{Float64}}, y::Vector{Vector{Float64}}, f::Function, Xsp::Vector{Vector{Float64}}, Usp::Vector{Vector{Float64}}, w::Vector{T}, ISet, tree) where T 
	@inbounds for i in 1:length(ISet)
		sample_points!(x, ISet[i], Xsp)
		nextstates!(y, f, x, Usp, w)
		_, hits = find_hits(y, tree)
		E[i] = hits
	end
end

function create_graph!(G::SimpleDiGraph{Int64}, E::Vector{Vector{Int64}})
	@inbounds for (i, hits) in enumerate(E)
		@inbounds for j in 1:length(hits)
			add_edge!(G,i,hits[j])
		end
	end
end

function create_graph(E::Vector{Vector{Int64}}, ncells::Int)
	G = SimpleDiGraph(ncells)
	create_graph!(G,E)
	return G
end

function analyze_graph(G::SimpleDiGraph{Int64})
	scc = strongly_connected_components(G)
	idx = 0
    len = 0
    @inbounds for i in 1:length(scc)
        l = length(scc[i])
        l > len && (idx = i; len=l) 
    end
    da = ancestors(G, scc[idx])
    return union(scc[idx],da)
end

# finds cells with path to scc
function ancestors(G::SimpleDiGraph{Int64}, src)
    reverse!(G)
    a = Vector{Int64}()
    @inbounds for (v, d) in enumerate(gdistances(G, src))
        if d < typemax(Int64)
            push!(a, v)
        end
    end
    reverse!(G)
    return a
end