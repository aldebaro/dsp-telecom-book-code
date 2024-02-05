import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import periodogram

N = 1024
A = 10
x = A * np.cos(2 * np.pi / 64 * np.arange(N))  # generate cosine
dw = 2 * np.pi / N  # FFT bin width

# First alternative: use the definition
S = np.abs(np.fft.fft(x)) ** 2 / N  # Periodogram (|FFT{x}|^2)/N
Power = 1 / (2 * np.pi) * (np.sum(S) * dw)  # Alternative, power from PSD

w, P = periodogram(x, fs=2*np.pi, scaling='spectrum')  # Use the periodogram function
Power2 = sum(P)*dw # calculate again, to compare with Power

# linear scale, then dB x w:
plt.figure()
plt.subplot(211)
plt.plot(P)
plt.ylabel('S[k]')  
plt.subplot(212)
plt.plot(w, 10 * np.log10(P))
plt.ylabel('S[k] (dB)')
plt.xlabel('k')
plt.show()