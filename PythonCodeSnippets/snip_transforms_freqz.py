import numpy as np
from numpy.fft import fft
import matplotlib.pyplot as plt

N1 = 5  # num. non-zero samples in the (aperiodic) pulse
x = np.concatenate((np.ones(N1), np.zeros(2)))  # Signal x[n]
halfN = 512
N = 2 * halfN  # Half of the DFT dimension and N
k = np.arange(N)  # Indices of freq. components
wk = k * 2 * np.pi / N  # Angular frequencies
Xk_fft = fft(x, N)  # Use 2N-DFT to get N positive freqs.
Xk_fft = Xk_fft[0:halfN]  # Discard negative freqs.
wk = (np.arange(halfN)) * (2 * np.pi / N)  # Positive freq. grid

plt.subplot(211)
plt.plot(wk, 20 * np.log10(abs(Xk_fft)))  # In dB
plt.subplot(212)
plt.plot(wk, np.angle(Xk_fft) * 180 / np.pi)  # In degrees
plt.show()
