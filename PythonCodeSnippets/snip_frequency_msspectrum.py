import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import welch
from scipy.signal.windows import hamming
from scipy.fft import fft

N = 1024  # Number of samples
x = 10 * np.cos(2 * 3 / 64 * np.arange(N))  # generate a cosine
Xk = (np.abs(fft(x)) / N) ** 2  # MS spectrum: |DTFS|^2
Fs = 2 * np.pi  # specify sampling frequence
myWindow = hamming(N)  # specify a Hamming window
_, H = welch(
    x, fs=Fs, window=myWindow, nfft=N, return_onesided=False
)  # Welch's estimate
H = Fs * H * np.sum(myWindow**2) / np.sum(myWindow) ** 2  # scale for MS
plt.plot(Xk, marker="X")  # compare
plt.plot(H, marker=".")
