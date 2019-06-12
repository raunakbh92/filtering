using Test
using Distributions
using Plots

include("burgard_pf.jl")

@testset "ransml" begin
	x = collect(range(-1,stop=3,length=50))[:,:]
	a1 = Normal(0.,0.4)
	a2 = Normal(0.2,0.4)
	a3 = Normal(0.4,0.4)
	a4 = Normal(0.6,0.4)
	a5 = Normal(0.8,0.4)
	y = -1.0*pdf.(a1,x) .+ -0.9*pdf.(a2,x) .+ 0.5*pdf.(a3,x) .+ 1.0*pdf.(a4,x) .+ 0.0*pdf.(a5,x)
	plot(x,y)
	savefig("media/ransml.png")
end

@testset "approx_func" begin
	x = collect(range(-1,stop=3,length=50))[:,:]
	means = [0.,0.2,0.4,0.6,0.8]
	stddevs = [0.4,0.4,0.4,0.4,0.4]
	weights = [-1.0,-0.9,0.5,1.0,0.0]
	y = approx_func(x,weights,means,stddevs)
	plot(x,y)
	savefig("media/myfunc.png")
end

@testset "obs_func" begin
	x = collect(range(0,stop=200,length=400))[:,:]
	y = obs_func(x,101.)
	plot(x,y)
	savefig("media/obsfunc.png")
end

"""
@testset "sample_particles" begin
	particles = sample_particles(3,10)
	@show particles
	@show typeof(particles)
	@show typeof(particles[1])
	@test length(particles) == 3
	@test length(particles[1]) == 10
end
"""
