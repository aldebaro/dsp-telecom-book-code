import numpy as np
import matplotlib.pyplot as plt

N = 1024
n = np.arange(0, N)
dw = 2 * np.pi / N
k1, k2 = 115.3, 500.8
w1, w2 = k1 * dw, k2 * dw

x = 10 * np.cos(w1 * n) + 1 * np.cos(w2 * n)

Sms = np.abs(np.fft.fft(x) / N) ** 2
S = np.abs(np.fft.fft(x)) ** 2 / N
Power = np.sum(Sms)

k = np.arange(0, N)

plt.subplot(211)
h = plt.plot(k, 10 * np.log10(Sms))
plt.title("MS Spectrum (dB)")

plt.subplot(212)
h2 = plt.plot(k, 10 * np.log10(S))
plt.title("Periodogram (dB)")

plt.show()
