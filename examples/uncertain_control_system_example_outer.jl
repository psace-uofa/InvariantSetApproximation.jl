using InvariantSetApproximation
# using Plots

# system model. should define x, u and w as arguments
model(x,u,w) = (x[2] + w[1], x[1] + x[2] + u[1] + w[2])

function main(model::Function, iter::Int)
    # state, input and uncertainty bounds
    Xub = [5., 5.]
    Xlb = [-5., -5.]
    Uub = [2.]
    Ulb = [-2.]
    Wub = [0.3, 0.3]
    Wlb = [-0.3, -0.3]

    # system
    S = system(model, Xlb, Xub, ulb=Ulb, uub=Uub, wlb=Wlb, wub=Wub)

    # options
    options = Dict(:max_step=>iter, :nXsamples=>5, :Xsampletype=>:face, :nUsamples=>5, :nWsamples=>2)
    O = Options(options)

    # computation
    sol = computeISet(S,O)

    return sol
end

# run main
sol = main(model, 14);
# find convexhull of set (for faster viewing of solution)
iset_cvxh = ConvexHullArray(sol.iset)
# uncomment to plot set
# plot(sol.iset) # slow if large number of cells are present
# plot(iset_cvxh)

println("done!")
