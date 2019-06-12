using Test
using Distributions
using Plots
using StatsBase
using Reel

include("burgard_pf.jl")

@testset "generate_particles" begin
	x = collect(range(0,stop=200,length=400))[:,:]
	means = [0,40,80,120,160,200]
	stddevs = [10,10,10,10,10,10]
	p_set = generate_particles(x,means,stddevs,100)
	@test size(p_set,1) == 400
	@test size(p_set,2) == 100
	plots = []
	plt0 = plot(x,p_set,leg=false)
	push!(plots,plt0)

	# Give same observation for n_step steps and see what happens
	for i in 1:50
		new_p_set = resample(x,p_set,101.)
		plt = plot(x,new_p_set,leg=false)
		push!(plots,plt)
		p_set = new_p_set
	end
	make_gif(plots)
end

"""
@testset "approx_func" begin
	x = collect(range(0,stop=200,length=400))[:,:]
	means = [0,40,80,120,160,200]
	stddevs = [10,10,10,10,10,10]
	n = length(means)
	selection = collect(range(0,stop=1,length=11)) # Specify 0,0.1,...,1.0 as possible coeffs

	num_particles = 100
	particle_set = zeros(size(x,1),num_particles) # Each column is a diff particle

	for i in 1:num_particles
		coeffs = rand(selection,n)
		y = approx_func(x,coeffs,means,stddevs)
		particle_set[:,i] = y
		#savefig(string("media/",string(coeffs,"_func.png")))
		#savefig("media/myfunc.png")
	end
	plot(x,particle_set,leg=false)
	savefig("media/myfunc.png")
end
"""

"""
@testset "obs_func" begin
	x = collect(range(0,stop=200,length=400))[:,:]
	y = obs_func(x,101.)
	plot(x,y)
	savefig("media/obsfunc.png")
end
"""

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

"""
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
"""
