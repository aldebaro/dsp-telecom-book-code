import matplotlib.pyplot as plt
import numpy as np
import pylab as pl
import scipy.signal as sp

x = np.array([1, -2, 3, 4, 5, -1])  # A signal
y = np.array([3, 1, -2, -2, 1, -4, -3, -5, -10])  # another sigal

####Crosscorrelation between they
c = sp.correlate(x, y)
lags = sp.correlation_lags(len(x), len(y))

index_max = max(range(len(c)), key=np.abs(c).__getitem__)
L = lags[index_max]  # lag for maximum abs crosscorelation

if L > 0:
    x = x[L:]  # deleting first L Samples from x
else:
    y = y[-L:]  # deleting first L Samples from y

if len(x) > len(y):  # making both length been the same
    x = x[0 : len(y)]
else:
    y = y[0 : len(x)]

plt.plot(np.array(x - y))
plt.title("Error between aligned x and y")
pl.show()
