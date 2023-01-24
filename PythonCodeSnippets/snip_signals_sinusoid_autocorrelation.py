import matplotlib.pyplot as plt
import numpy as np
import pylab as pl

numSamples = 48
n = np.arange(0, numSamples)
N = 15
x = 4 * np.sin(2 * np.pi / N * n)
H = plt.acorr(x, usevlines=False, normed=False, maxlags=47, lw=2)
l = H[0]
R = H[1]
plt.subplot(2, 1, 1)
plt.plot(l, R)
plt.ylabel("Unbiassed Rx[I]")
plt.subplot(2, 1, 2)
plt.plot(n, x)
plt.ylabel("Raw Rx[I]")
plt.xlabel("Lag I")
pl.show()
