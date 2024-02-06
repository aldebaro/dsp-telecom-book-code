import numpy as np
from scipy.signal import welch, windows
import matplotlib.pyplot as plt

N = 3000  # total number of signal samples
Nfft = 32  # segment length M and also FFT-length
Fs = 1  # assumed bandwidth for discrete-time signal
power_x = 600  # noise power in Watts

# Gaussian white noise
x = np.sqrt(power_x) * np.random.randn(N)

# Parameter [] is because in Matlab it is num. samples while Octave is percent (%)
f, Sk = welch(x, window=windows.hamming(Nfft), nperseg=Nfft, fs=Fs)

print("Periodogram standard deviation=", np.std(Sk))

# periodogram with Fs=1 is discrete-time PSD
plt.plot(2 * np.pi * f, Sk)

# PSD theoretical value
plt.plot(f, power_x * np.ones_like(f), "r")
plt.show()
