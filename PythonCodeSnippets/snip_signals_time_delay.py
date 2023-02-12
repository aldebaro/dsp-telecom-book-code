import matplotlib.pyplot as plt
import numpy as np
import pylab as pl
import scipy.signal as sp
from numpy import random as rd

Fs = 8000  # sampling frequency
Ts = 1 / Fs  # Sampling Period
N = 1.5 * Fs  # Define a time of 1.5 second
t = np.arange(0, N) * Ts
print(len(t))
if 1:
    X = rd.rand(int(N)) - 0.5
else:
    X = np.cos(2 * np.pi * 100 * t)
dalayInSamples = 2000
timeDelay = dalayInSamples * Ts
zero = np.zeros(dalayInSamples)
auxX = X[0 : len(X) - dalayInSamples]
y = np.concatenate((zero, auxX))
SNRdb = 10
signalPower = np.mean(X**2)
noisePower = signalPower / (10 ** (SNRdb / 10))
noise = np.sqrt(noisePower) * rd.randn(np.size(y))
y = y + noise
plt.figure()
plt.subplot(211)
plt.plot(t[0:5000], X[0:5000])
plt.plot(t[0:5000], y[0:5000])

plt.subplot(212)

c = sp.correlate(X, y, "full")
lags = sp.correlation_lags(len(X), len(y), "full")

plt.plot(lags * Ts, c)
pl.show()
index_max = max(range(len(c)), key=np.abs(c).__getitem__)
L = lags[index_max]
estimated_time_delay = L * Ts
print(estimated_time_delay)
