import numpy as np
import matplotlib.pyplot as plt

N = 1024
A = 4  # Cosine amplitude of A Volts
Fs = 8000
Ts = 1 / Fs  # Sampling frequency (Hz) and period (s)
f0 = 915  # Cosine frequency in Hz
noise_power = 16  # Noise power in Watts

# Generate time vector
t = np.arange(0, N * Ts, Ts)

# Generate cosine with AWGN
noise = np.sqrt(noise_power) * np.random.randn(N)
x = A * np.cos(2 * np.pi * f0 * t) + noise

# Periodogram
f, P = plt.psd(x, NFFT=N, Fs=Fs, scale_by_freq=False)

# Plot periodogram on a dB scale
plt.plot(f, 10 * np.log10(P))
plt.xlabel('Frequency (Hz)')
plt.ylabel('Power/Frequency (dB/Hz)')
plt.show()
