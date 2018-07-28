mutable struct BinaryKnapsack <: AbstractKnapsack
    #========================================================
        Problem Data
    ========================================================#
    n::Int  # Number of items
    w::Vector{Int}  # Items' weights
    v::Vector{Int}  # Items' values
    b::Int  # Capacity of the knapsack
    perm::Vector{Int}  # permuted order of the items

    #========================================================
        Solution Data
    ========================================================#   
    x_best::Vector{Bool}  # best feasible solution
    z_best::Int  # Best objective value
    w_best::Int  # Total weight of best solution

    function BinaryKnapsack(w, v, b) 
        
        # Dimension checks
        n = size(w, 1)
        n == size(v, 1) || throw(DimensionMismatch("w has size $(size(w)) but v has size $(size(v))"))

        knp = new()

        knp.n = n
        knp.w = copy(w)
        knp.v = copy(v)
        knp.b = b
        knp.perm = collect(1:n)
        
        knp.x_best = zeros(Bool, n)
        knp.z_best = zero(Int)
        return knp
    end

end

"""
    get_item_weights(knp::BinaryKnapsack)

Return the vector of items' weights. Items are ordered as in the original
"""
get_item_weigths(knp::BinaryKnapsack) = copy(knp.w[knp.perm])
get_item_values(knp::BinaryKnapsack) = copy(knp.v[knp.perm])
get_item_order(knp::BinaryKnapsack) = copy(knp.perm)
get_knapsack_capacity(knp::BinaryKnapsack) = knp.b

get_knapsack_best_solution(knp::BinaryKnapsack) = copy(knp.x_best[knp.perm])


function greedy_heuristic!(knp::BinaryKnapsack)

    x = zeros(Bool, knp.n)  # current solution
    z = 0  # current objective
    b = knp.b  # current remaining capacity

    for i in 1:knp.n
        if b >= knp.w[i]
            x[i] = true
            z += knp.v[i]
            b -= knp.w[i]
        end

        if b <= 0
            break
        end

    end

    if z > knp.z_best
        knp.x_best .= x
        knp.z_best = z
        knp.w_best = knp.b - b
    end

    return z
end

"""
    sort_items!(knp::BinaryKnapsack)

Sort items by decreasing ratio `v[i]/w[i]`
"""
function sort_items!(knp::BinaryKnapsack)

    # compute ratios
    r = knp.v ./ knp.w

    # sort
    p = sortperm(r, rev=true)
    for (i, j) in enumerate(p)
        knp.perm[j]= i
    end

    knp.v .= knp.v[p]
    knp.w .= knp.w[p]

    return nothing
end

