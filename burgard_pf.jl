# Approximate a function using gaussian basis function
function approx_func(x::Array{Float64,2},weights::Array,
			means::Array,stddevs::Array)
	y = zeros(size(x))
	# Loop over all the basis functions	
	for i in 1:length(means)
		y = y+weights[i]*pdf.(Normal(means[i],stddevs[i]),x)
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

"""
Create the particles. Called it sample specifically to highlight
the reason why resample is called resample and not just plain sample. 
The first time, we sample particles when we create our array of particles.
All subsequent is thus called resampling
"""
function sample_particles(num_particles::Int,num_cells::Int)
	particles = []	
	for i in 1:num_particles
		push!(particles,rand(num_cells))
	end
	return particles
end

"""
Inverse sensor model
z is the measurement in terms of distance from robot (who is assumed to be fixed at org)
c is the distance from robot
"""
function log_inv_sensor_model(z,c)
	if c > z
		# Wall detected for this cell		
		return log(0.6)
	else
		# Free space detected for this cell		
		return log(0.3)
	end
end # End the inverse sensor model

"""
log prob of occupancy of map represened by particle given measurement
A particle is a vector of 10 elements with each element 
correspond to prob of cell being occupied
"""
function weight_particle(particle,obs)
	ll = 0
	for i in 1:length(particle)
		ll=ll+log_inv_sensor_model(obs,particle[i])
	end
	return ll
end

function resample_particles()

end
