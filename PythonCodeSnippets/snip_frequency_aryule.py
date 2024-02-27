import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import lfilter, freqz
from scipy.signal import welch
from aryule_function import aryule

N = 100000
x = np.random.randn(N)  # WGN with zero mean and unit variance
Px = np.mean(np.abs(x) ** 2)  # input signal power
B = [4.0]  # filter numerator
A = [1.0, 0.5, 0.98]  # filter denominator
Fs = 1  # sampling frequency Fs = BW = 1 DHz
y = lfilter(B, A, x)  # realization of an AR(2) process
Py = np.mean(np.abs(y) ** 2)  # output power

for P in range(1, 5):  # vary the filter order
    f, Sy = welch(y, window="rect", nperseg=N, fs=Fs,noverlap=None, return_onesided=False)
    w, Hthe = freqz(B, A, worN=N, whole=True)
    Ahat, Perror, rc = aryule(y, P)  # estimate filter of order P
    w, Hhat = freqz(np.sqrt(Perror), Ahat, worN=N, whole=True)

    plt.figure()
    plt.plot(np.fft.fftshift(2 * np.pi * f) + np.pi, 10 * np.log10(Sy), "r")
    plt.plot(w, 10 * np.log10(Px * np.abs(Hhat) ** 2), "b")
    plt.plot(w, 10 * np.log10(Px * np.abs(Hthe) ** 2), "k--")
    plt.legend(["Welch", "Theoretical", "AR"])
plt.show()
