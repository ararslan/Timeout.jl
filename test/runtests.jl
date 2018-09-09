using Compat.Distributed

if nprocs() > 1
    error("For the Timeout package's tests to be reliable, Julia must be started with" *
          "only a single worker process.")
end

# We need 2 because one will get terminated by the ptimeout test, which means there
# wouldn't be any remaining workers for the following test
addprocs(2)

using Timeout
using Compat.Test
using Compat.Dates

#@testset "No process available" begin
#    @test_throws ArgumentError ptimeout(()->1, 20, worker=2)
#end

@testset "Misspecified options" begin
    @test_throws ArgumentError ptimeout(()->8+1, 44.4, worker="nope")
    @test_throws ArgumentError ptimeout(()->sin(π), 3, worker=myid())
    @test_throws ArgumentError ptimeout(()->cos(π), 2, worker=2, poll=-1)
end

@test !ptimeout(Second(4), worker=2) do
    while true
        sin(rand())
    end
end

@test @ptimeout 3 4.5 begin
    for i = 1:10
        cos(i)
    end
end
