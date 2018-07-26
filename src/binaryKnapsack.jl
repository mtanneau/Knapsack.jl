mutable struct BinaryKnapsack <: AbstractKnapsack
    #========================================================
        Problem Data
    ========================================================#
    n::Int  # Number of items
    w::Vector{Int}  # Items' weights
    v::Vector{Int}  # Items' values
    b::Int  # Capacity of the knapsack

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
        knp.w = w
        knp.v = v
        knp.b = b
        
        knp.x_best = zeros(Bool, n)
        knp.z_best = zero(Int)
        return knp
    end

end

function greedy_heuristic(knp::BinaryKnapsack)

    x = zeros(Bool, knp.n)  # current solution
    z = 0  # current objective
    b = knp.b  # current remaining capacity

    for i in 1:knp.n
        if b > knp.w[i]
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

