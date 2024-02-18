import numpy as np
import matplotlib.pyplot as plt

Fs = 8000  # sampling frequency (Hz)
Ts = 1 / Fs  # sampling interval (seconds)
f0 = 2400  # cosine frequency (Hz)
N = 40  # number of desired samples
n = np.arange(N)  # generate discrete-time abscissa
t = n * Ts  # discretized continuous-time axis (sec.)
x = 6 * np.cos(2 * np.pi * f0 * t)  # amplitude=6 V and frequency = f0 Hz

# Plot discrete-time signal
plt.subplot(2, 1, 1)
plt.plot(t, x)

# Create an oversampled version of signal x
oversampling_factor = 200
oversampled_Ts = Ts / oversampling_factor
oversampled_n = np.arange(n[0] * oversampling_factor, n[-1] * oversampling_factor + 1)
oversampled_t = oversampled_n * oversampled_Ts  # oversampled discrete-time
xo = 6 * np.cos(2 * np.pi * f0 * oversampled_t)  # oversampled discrete-time signal

# Plot of the oversampled signal
plt.subplot(2, 1, 2)
plt.plot(oversampled_t, xo)

# Display the plots
plt.tight_layout()
plt.show()
