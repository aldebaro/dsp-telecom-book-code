import numpy as np
import matplotlib.pyplot as plt

N = 10000
w = np.linspace(-np.pi, np.pi, N)
Xejw = 1.0 / (1 - 0.9 * np.exp(-1j * w))

Fs = 5000
Ts = 1 / Fs
W = np.linspace(-4 * 2 * np.pi * Fs, 4 * 2 * np.pi * Fs, N)
XejW = 1.0 / (1 - 0.9 * np.exp(-1j * W * Ts))

plt.figure()
plt.subplot(2, 1, 1)  # 2 rows, 1 column, first plot
plt.plot(w, np.abs(Xejw), label="Xejw")
plt.legend()

plt.subplot(2, 1, 2)  # 2 rows, 1 column, second plot
plt.plot(W, np.abs(XejW), label="XejW")
plt.legend()

plt.show()
