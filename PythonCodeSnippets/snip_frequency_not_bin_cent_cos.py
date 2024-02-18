import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import periodogram

N = 1024
n = np.arange(0, N)
dw = 2 * np.pi / N
k1, k2 = 115.3, 500.8
w1, w2 = k1 * dw, k2 * dw

x = 10 * np.cos(w1 * n) + 1 * np.cos(w2 * n)

Sms = np.abs(np.fft.fft(x) / N) ** 2
w = np.linspace(0, np.pi, len(Sms))

frequencies, S = periodogram(x)

Power = np.sum(Sms)

k = np.arange(0, N)

plt.subplot(211)
h = plt.plot(k, 10 * np.log10(Sms))
plt.title("MS Spectrum (dB)")

plt.subplot(212)
h2 = plt.plot(frequencies, 10 * np.log10(S))
plt.title("Periodogram (dB)")

plt.show()
