module ParallelMap

using Base.Threads

export parmap, parmap!


"""
    parmap(f, xs)

# Description 

Applies the function `f` to each element of the input vector `xs` in parallel using 
multiple threads. The results are collected into a new vector, which is returned.

# Arguments

- `f::F`: A function that takes a single argument. This function will be applied to each element of `xs`.
- `xs::AbstractVector`: An input vector containing the elements to which the function `f` will be applied.

# Returns

A new vector containing the results of applying `f` to each element of `xs`. The type of the elements in the returned vector is determined by the return type of the function `f` when applied to the elements of `xs`.

# Example

```julia
using ParallelMap
result = parmap(x -> x^2, [1, 2, 3])
println(result)  # Output: [1, 4, 9]
```
"""
function parmap(f::F, xs::AbstractVector) where F <: Function
    N = length(xs)
    N == 0 && return []
    typ = Core.Compiler.return_type(f, Tuple{eltype(xs)})
    results = Vector{typ}(undef, N)
    @inbounds Threads.@threads for i in 1:N
        results[i] = f(xs[i])
    end
    return results
end 



"""
    parmap!(f, xs, results)

# Description

Applies the function `f` to each element of the input vector `xs` in parallel using
multiple threads, storing the results in a preallocated `results` vector. 
The length of the `results` vector must match the length of the input vector `xs`.

# Arguments

- `f::F`: A function that takes a single argument. This function will be applied to each element of `xs`.
- `xs::AbstractVector`: An input vector containing the elements to which the function `f` will be applied.
- `results::Vector`: A preallocated vector where the results of applying `f` to each element of `xs` will be stored. The length of this vector must match the length of `xs`.

# Returns

The `results` vector after it has been populated with the results of applying `f` to each element of `xs`.

# Example

```julia
using ParallelMap
results = Vector{Float64}(undef, 3)
parmap!(x -> x^2, [1, 2, 3], results)
println(results)  # Output: [1.0, 4.0, 9.0]
``` 
"""
function parmap!(f::F, xs::AbstractVector, results::AbstractVector) where F <: Function
    len = length(xs) 
    len != length(results) && throw(ArgumentError("Length of results vector must match length of input vector"))
    len == 0 && return results 
    @inbounds Threads.@threads for i in 1:len
		results[i] = f(xs[i])
    end
    return results
end 



"""

    parmap(f, xs, returnType)

# Description

Applies the function `f` to each element of the input vector `xs` in parallel using
multiple threads, and returns a new vector of a specified return type. 
This function is useful when you want to ensure that the results are stored in a vector of a specific type, 
regardless of the return type of the function `f`.

# Arguments

- `f::F`: A function that takes a single argument. This function will be applied to each element of `xs`.
- `xs::AbstractVector`: An input vector containing the elements to which the function `f` will be applied.
- `returnType::Type`: The desired return type for the elements in the resulting vector. The function will attempt to convert the results of applying `f` to this type.

# Returns

A new vector containing the results of applying `f` to each element of `xs`, with the elements converted to the specified `returnType`.

# Example

```julia
using ParallelMap
result = parmap(x -> x^2, [1, 2, 3], Float64)
println(result)  # Output: [1.0, 4.0, 9.0]
``` 

"""
function parmap(f::F, xs::AbstractVector, returnType::Type) where F <: Function
    N = length(xs)
    N == 0 && return Vector{returnType}()
    results = Vector{returnType}(undef, N)
    @inbounds Threads.@threads for i in 1:N
        results[i] = f(xs[i])
    end
    return results
end

end # module ParallelMap
