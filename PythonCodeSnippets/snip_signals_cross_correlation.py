import matplotlib.pyplot as plt
import numpy as np
import pylab as pl
import scipy.signal as sp

x = np.arange(1, 4)
y = np.concatenate([np.arange(3, 0, -1), x])
c = sp.correlate(x, y)
lags = sp.correlation_lags(len(x), len(y))

L = lags[max(range(len(c)), key=np.abs(c).__getitem__)]
plt.stem(lags, c)
plt.ylabel("cross-correlation")
plt.xlabel("lag (samples)")
pl.show()
