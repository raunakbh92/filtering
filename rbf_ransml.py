import numpy as np
import matplotlib.pyplot as pl
from scipy.special import expit

#generate basis function
def getBasis(x, mu_rbf, sigma_rbf):

    theta_rbf = np.exp(-((x-mu_rbf)**2)/(2*(sigma_rbf**2)))

    return theta_rbf

# Number of basis functions
order = 5
sigma_rbf = 0.4
mu_rbf = np.array([range(order)])*0.2

print(mu_rbf)

#Let's plot for some x values
x = np.linspace(-1, 3)[:,None] # Returns 50 elements by default
y = getBasis(x, mu_rbf, sigma_rbf)
print(y.shape) # Will be (50,order)

# Plot the basis functions
plotbasis = False
if plotbasis:
	pl.plot(x, y)
	pl.show()

#Let's define weights
weights = np.array([-1.0, -0.9, 0.5, 1.0, 0.0])

prod = y.dot(weights)

# Plot which basis functions create an impact
plotimpact = False
if plotimpact:
	pl.plot(x, y*weights)
	pl.show()

# Plot the resulting functional shape
plotfunc = True

if plotfunc:
	pl.plot(x, prod, c='k')
	pl.show()

# Plot the logistic function of the functional shapee
plotlogistic = True
if plotlogistic:
	pl.plot(x, expit(prod), c='b')
	pl.show()
