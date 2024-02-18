import numpy as np
from scipy.signal import welch
from scipy.fftpack import fft

N = 1000
x = 10 * np.cos(2 * np.pi / 64 * np.arange(N))  # generate a cosine
Xk = (np.abs(fft(x, N)) / N) ** 2  # MS spectrum |Xk|^2
Fs = 2 * np.pi
window = np.hamming(128)  # specify Fs and window
f, Pxx = welch(
    x, Fs, window=window, nperseg=128, return_onesided=False
)  # Welch's estimate
H = 2 * np.pi * Pxx * np.sum(window**2) / np.sum(window) ** 2  # scale for MS
print("Peak from pwelch = {} Watts".format(np.max(H)))
print("Peak when using one FFT = {} W".format(np.max(Xk)))
