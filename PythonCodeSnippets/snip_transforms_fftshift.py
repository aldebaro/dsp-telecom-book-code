import numpy as np
from numpy.fft import fft, fftshift
import matplotlib.pyplot as plt

N = 12  # Period in samples
n = np.arange(N)  # Vector representing abscissa
A = 10
x = A * np.cos(np.pi / 6 * n + np.pi / 3)  # Cosine with amplitude 10 V
X = (1 / N) * fft(x)  # Calculate DFT and normalize to obtain DTFS
k = np.arange(-N / 2, N / 2)  # Range with negative k (assume N is even)
X[abs(X) < 1e-12] = 0  # Discard small values (numerical errors)
X = fftshift(X)  # Rearrange to represent negative freqs.

plt.subplot(211)
plt.stem(k, abs(X), basefmt="")
plt.subplot(212)
plt.stem(k, np.angle(X), basefmt="")
plt.show()
