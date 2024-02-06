import numpy as np
import matplotlib.pyplot as plt

power = 8  # Watts
N = 10000  # number of samples
x = np.sqrt(power) * np.random.randn(N)  # white noise signal
Fs = 40
maxLag = 100  # maximum lag

# Biased autocorrelation
R = np.correlate(x, x, mode='full') / N  # divide by N for biased autocorrelation
l = np.arange(-maxLag, maxLag + 1)  # lag values corresponding to R

# Plotting
plt.stem(l, R[N-1:N+maxLag*2])  # Adjust the indexing here
plt.xlabel('lag l')
plt.ylabel('autocorrelation R[l]')
plt.show()
