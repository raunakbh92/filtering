# Approximate a function using gaussian basis function
# coeffs used not to confuse with the weights function used from StatsBase
function approx_func(x::Array{Float64,2},coeffs::Array,
			means::Array,stddevs::Array)
	@assert length(means) == length(stddevs)	
	y = zeros(size(x))
	scale = 15.0 #XXX Ask Ransalu about this
	# Loop over all the basis functions	
	for i in 1:length(means)
		y = y+scale*coeffs[i]*pdf.(Normal(means[i],stddevs[i]),x)
	end
	return y
end

# Returns a vector that captures the form of the observation function
# as per the inverse sensor model
function obs_func(x::Array{Float64,2},obs::Float64)
	y = 0.3*ones(size(x))
	y[findall(p->p>obs,x)] .= 0.6 # .= needed because we are changing more than 1 elem
	y[findall(p->p>obs+20.,x)] .= 0.5
	return y
end

# Generate particles
# Every column is a different particle
# Every row is a different sample from the function
### XXX: Need to figure out how to enforce that impossible functions dont pollute us
	# Example: Negative value of function not allowed
function generate_particles(samples::Array{Float64,2},means::Array,
			stddevs::Array,num_particles::Int64)
	x = samples # Because changed name to samples later	
	n = length(means)
	selection = collect(range(0,stop=1,length=11)) # Specify 0,0.1,...,1.0 as possible coeffs

	particle_set = zeros(size(x,1),num_particles) # Each column is a diff particle
	coeff_set = zeros(n,num_particles)
	for i in 1:num_particles
		coeffs = rand(selection,n)
		coeff_set[:,i] = coeffs
		y = approx_func(x,coeffs,means,stddevs)
		particle_set[:,i] = y
	end
	return particle_set,coeff_set
end

# resample
	#XXX needs statsbase to work `weights` and `sample` methods
function resample(samples::Array{Float64,2},p_set::Array{Float64,2},
			coeff_set::Array{Float64,2},obs::Float64)
	obs_vec = obs_func(samples,obs)
	# XXX Need to think about this divide 1 over sumofdiff	
		# Rationale is that more the diff, worse the particle
	sum_of_diffs = 1 ./ sum(abs.(p_set .- obs_vec),dims=1) # Returns a 1xnum_particles array

	particle_weights = weights(sum_of_diffs./sum(sum_of_diffs))
	
	num_p = size(p_set,2)	
	idx = sample(1:num_p,particle_weights,num_p)
	new_particle_set = p_set[:,idx]
	new_coeff_set = coeff_set[:,idx]
	return new_particle_set, new_coeff_set
end

function make_gif(plots)
@show "Making gif"
	frames = Frames(MIME("image/png"), fps=1)
	for plt in plots
	    push!(frames, plt)
	end
	write("media/output.mp4", frames)
	return nothing
end # End of the reel gif writing function
