import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import periodogram, boxcar

N = 1024
A = 10
x = A * np.cos(2 * np.pi / 64 * np.arange(N))  # generate cosine
Fs = 8000  # sampling frequency in Hz
rectWindow = boxcar(N)  # rectangular window
f, P = periodogram(x, window=rectWindow, nfft=N, fs=Fs)  # periodogram
df = Fs / N  # FFT bin width to be used in power computation
Power = np.sum(P) * df  # calculate the average power
print("Power:", Power)
plt.plot(f / 1000, 10 * np.log10(P))  # convert to dBW/Hz
plt.grid()
plt.show()
