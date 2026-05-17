# ParallelMap.jl


Parallel Map in Julia

# Installation 

The package has not been registered, yet. Install it using the source repository:

```julia
julia> ]
Pkg> add https://github.com/jbytecode/ParallelMap.jl.git 
```

# Basic Usage 


## parmap 

No pre-allocations. It's like standard `map` function of Julia. Return type is 
inferred by using `Core.Compiler.return_type`: 

```julia
parmap(x -> x^2, [1, 2, 3])
```

The other use is specifying the return type of the function.

```julia
parmap(x -> x^2, [1, 2, 3], Float64)
```

## parmap!

Results are hold in a pre-allocated vector (in-place calculations):

```julia
results = Vector{Float64}(undef, 3)
parmap!(x -> x^2, [1, 2, 3], results)
```

