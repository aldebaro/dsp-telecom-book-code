import matplotlib.pyplot as plt
import numpy as np
import pylab as pl

x = np.array([3, 0, 4, 0, 5])  # some signal sample
y = np.fliplr([x])  # signal - reversal
y = y[0]
n1 = np.arange(0, 5)  # time
n2 = np.arange(-4, 1)  # time reversal

plt.subplot(211)
plt.title("X[n")
plt.stem(n1, x)

plt.subplot(212)
plt.title("Y[n")
plt.stem(n2, y)


pl.show()
