import numpy as np
from scipy.fft import fft

N = 1024  # number N of samples
n = np.arange(N)
A = 10
x = A * np.cos((2 * np.pi / 64) * n)  # generate cosine with period 64
Sms = np.abs(fft(x) / N) ** 2  # MS spectrum |DTFS{x}|^2
BW = 1  # assumed bandwidth is 2*pi
S = np.abs(fft(x)) ** 2 / (BW * N)  # Periodogram (|FFT{x}|^2)/(BW * N)
Sms2 = BW * S / N  # Example of obtaining MS spectrum from periodogram
Power = np.sum(Sms)  # Obtaining power from the MS spectrum
Power2 = np.sum(S) * BW / N  # Obtaining power from the periodogram
