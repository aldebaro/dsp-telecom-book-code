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

fig,axs = plt.subplots(2,1)

axs[0].stem(n,x)
axs[0].set_ylabel("X[n]")
axs[0].set_xlabel("n")

axs[1] = plt.subplot(2,1,2)
axs[1].stem(l,R)
axs[1].set_ylabel("R_x[l]")
axs[1].set_xlabel("Lag l")

pl.show()