import matplotlib.pyplot as plt
import numpy as np
import pylab as pl
from scipy.io.wavfile import write

Fs = 8000  # Defining a sampling frequency (Hz)
Ts = 1 / Fs  # Defining a sampling period (seconds)
N = 20000  # Number of samples
f0 = 600  # Cosine frequency in Hz
# First method to generate a cosine with frequency equals to 600 Hz
t = np.arange(0, (N - 1) * Ts, Ts)  # Discretized continuous-time (seconds)
x1 = 5 * np.cos(2 * np.pi * f0 * t)
# Second metod: work with in discrete-time
w0 = 2 * np.pi * f0 * Ts  # w0 is the discrete-time angular frequency (radians)
n = np.arange(0, N - 1, 1)  # Using a discrete-time axis
x2 = 5 * np.cos(w0 * n)  # Getting that cosine now with this new method
# Getting the error between that two metods
Error = x1 - x2
print("Average error =", np.mean(Error))
plt.plot(n, Error)
pl.show()
write("output.wav", Fs, x1)  # save the first signal to a wav file
