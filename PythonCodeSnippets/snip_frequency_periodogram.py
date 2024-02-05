import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import periodogram

N = 16
alpha = 2
A = 10
n = np.arange(N)
x = A * np.cos((2 * np.pi * alpha / N) * n)  # generate cosine
BW = 1  # it is a discrete-time signal, assume BW=1 Hz
Sk = (1 / (N * BW)) * np.abs(np.fft.fft(x)) ** 2  # Periodogram as defined in text
Power = (BW / N) * np.sum(Sk)  # Obtain power from periodogram

_, Smatlab = periodogram(x, fs=BW, nfft=N, return_onesided=False)  # from f=0 to 1 dHz
M = len(Smatlab)  # periodogram used zero-padding and unilateral PSD
dhertz = (1 / N) * np.arange(-N / 2, N / 2)  # normalized frequency
Power2 = (BW / N) * np.sum(Smatlab)  # Power from periodogram function

W = 2 * np.pi * dhertz  # convert abscissa to Omega in radians

# plot the periodogram
plt.figure()
plt.subplot(211)
plt.stem(W, np.fft.fftshift(Smatlab))
plt.stem(W, np.fft.fftshift(Sk), 'xr')
plt.show()