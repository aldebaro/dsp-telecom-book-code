import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import lfilter, freqz
from scipy.signal import welch, windows
from aryule_function import aryule

N = 100000
x = np.random.randn(N)  # WGN with zero mean and unit variance
y = lfilter([4], [1, 0.5, 0.98], x)  # realization of an AR(2) process
A, Perror, rc = aryule(y, 2)  # estimate filter via LPC
# pwelch input values
noverlap = 50
Nfft = 2048
Fs = 1

f, Pxx = welch(
    y,
    fs=Fs,
    window=np.hamming(Nfft),
    noverlap=noverlap,
    nperseg=Nfft,
    return_onesided=False,
)  # PSD
# Pxx = 2*np.pi*Pxx

w, H = freqz(1, A, worN=Nfft, whole=True)  # get frequency response of H(z)
Shat = Perror * (np.abs(H) ** 2)  # get PSD estimated via autoregressive model

plt.figure()
plt.plot(
    np.fft.fftshift(2 * np.pi * f) + np.pi, 10 * np.log10(Pxx), label="Estimated PSD"
)  # Plot the estimated PSD
plt.plot(w, 10 * np.log10(Shat), label="AR Model PSD")  # Plot the AR model PSD
plt.xlabel(r"$\Omega$ (rad)")
plt.ylabel("S(e^{j$\Omega$})  dBW/Dhz")
plt.legend()
plt.axis("tight")
plt.show()
