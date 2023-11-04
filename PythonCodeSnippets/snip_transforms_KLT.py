import numpy as np
from numpy.random import default_rng
import matplotlib.pyplot as plt

rng = default_rng()  # Random number generator
N = 100# Number of vectors
K = 4# Vector dimension
line = np.arange(N * K) + 1  # Straight line
noisePower = 2 # Noise power in Watts

temp = np.transpose(np.reshape(line, (K, N), order="F"))  # Block signal
x = temp + np.sqrt(noisePower) * rng.standard_normal(temp.shape) # Add (AWGN) noise

z = np.transpose(x)
plt.plot(z.ravel(order="F"))  # Prepare for plot
plt.show()
