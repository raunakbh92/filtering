# This julia code been transcribed from the python code found in soln of Burgard class
# That document is called Burgard_sheet09sol.pdf

# Learnings while writing this code
	# 1. Need to broadcast everything explicity using . (see m calculation)
	# 2. Need end to finish control statements
	# 3. Need to use the collect() to transform range to an array
	# 4. Going from python to julia is not too hard

using Plots
using Reel


# gif making function
function make_gif(plots)
@show "making animation"
	frames = Frames(MIME("image/png"), fps=1)
	for plt in plots
	    push!(frames, plt)
	end
	write("burgard.mp4", frames)
	return nothing
end # End of the reel gif writing function

# Inverse sensor model in log-odds form
function log_inv_sensor_model(z,c)
	if c > z
		# Wall detected for this cell		
		return log(0.6/(1-0.6))
	else
		# Free space detected for this cell		
		return log(0.3/(1-0.3))
	end
end # End the inverse sensor model


function runexp()
	# Cell position in cm for each cell
	c = collect(range(0,stop=200,step=10))

	# Map belief in log odds form
	logodds = zeros(length(c))

	# Set of measurements (in cm)
	meas = [101,82,91,112,99,151,96,85,99,105]

	# Initial prior of the cells, the non informatve prior will
	# of p = 0.5 will yield 0 in log-odds form, so techically
	# we can leave it out in the log odds formula
	prior = log(0.5/(1-0.5))

	plots = [] # Store the plot after seeing each new measurement
	m = 1 .- 1 ./ (1 .+ exp.(logodds))
	plt0 = plot(c,m,markershape=:rect)
	push!(plots,plt0)

	# Integrate each measurement
	for i in 1:length(meas)
		# Update every cell of the map
		for j in 1:length(c)
			# Anything beyong 20 cm of the measurement should not be updated
			if c[j] > meas[i] + 20
				#@show "Beyong 20 cm. Don't update"			
				continue
			end
			#@show "Not beyond 20. So need to update"
			logodds[j] = logodds[j] - prior + log_inv_sensor_model(meas[i],c[j])
		end
		
		# Inverse transform from log odds to probability		
		m = 1 .- 1 ./ (1 .+ exp.(logodds))


		plt = plot(c,m,markershape=:rect)
		annotate!(30,0.5,string(string("step=",i),string(",obs=",meas[i])))
		push!(plots, plt)
	end # End of the loop over measurements

	return plots
end # End the exp run function


@show "Burgard is running"
plots = runexp()
make_gif(plots)

# Apply the inverse transformation from log-odds to probability
#@show length(logodds)
#m = 1 .- 1 ./ (1 .+ exp.(logodds))

# Plot the resulting estimate
#plot(c,m)
#savefig("graph.png")
