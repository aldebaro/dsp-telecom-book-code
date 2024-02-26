import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import lfilter, freqz
from scipy.signal import welch
from aryule_function import aryule

N = 100000
x = np.random.randn(N)  # WGN with zero mean and unit variance
Fs = 600  # assumed sampling frequency in Hz
y = lfilter([4], [1, 0.5, 0.98], x)  # realization of an AR(2) process

A, Perror, rc = aryule(y, 2)  # estimate filter via LPC
noverlap = 50
Nfft = 2048
f, Pxx = welch(y, fs=Fs, nperseg=Nfft, noverlap=noverlap)
w, H = freqz(1, A, worN=Nfft)
N0div2 = Perror / Fs
Shat = N0div2 * (np.abs(H) ** 2)
Shat = np.concatenate(([Shat[0]], 2 * Shat[1:-1], [Shat[-1]]))

# Plot PSD
plt.plot(f, 10 * np.log10(Pxx), label="Welch PSD")
plt.plot(w * Fs / (2 * np.pi), 10 * np.log10(Shat), "k", label="Estimated PSD (AR)")
plt.xlabel("Frequency [Hz]")
plt.ylabel("Power/Frequency [dB/Hz]")
plt.title("Welch Power Spectral Density Estimate")
plt.grid()
plt.tight_layout()
plt.show()
