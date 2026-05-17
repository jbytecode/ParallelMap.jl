using Test 
using ParallelMap

@testset "Standart map" begin 
    @test map(x -> x^2, [1, 2, 3]) == [1, 4, 9]
    @test map(x -> x^2, Float64[]) == Float64[]
    result = map(x -> sin(x)^2 + cos(x)^2, [i for i in 1:10000])
    @test all(isapprox.(result, 1.0))
end 

@testset "parmap with no return type" begin
    @test parmap(x -> x^2, [1, 2, 3]) == [1, 4, 9]
    @test parmap(x -> x^2, Float64[]) == Float64[]
    result = parmap(x -> sin(x)^2 + cos(x)^2, [i for i in 1:10000])
    @test all(isapprox.(result, 1.0))
end


@testset "parmap with specified return type" begin
    @test parmap(x -> x^2, [1, 2, 3], Float64) == [1.0, 4.0, 9.0]
    @test parmap(x -> x^2, Int[], Float64) == Float64[]
    result = parmap(x -> sin(x)^2 + cos(x)^2, [i for i in 1:10000], Float64)
    @test all(isapprox.(result, 1.0))
end

@testset "parmap with preallocated results vector" begin
    results = Vector{Float64}(undef, 3)
    @test parmap!(x -> x^2, [1, 2, 3], results) == [1.0, 4.0, 9.0]
    @test parmap!(x -> x^2, Int[], Float64[]) == Float64[]
    results = Vector{Float64}(undef, 10000)
    result = parmap!(x -> sin(x)^2 + cos(x)^2, [i for i in 1:10000], results)
    @test all(isapprox.(result, 1.0))
end