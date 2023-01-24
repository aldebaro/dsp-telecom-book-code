import matplotlib.pyplot as plt
import numpy as np
import pylab as pl
import scipy.signal as sp

Fs = 44100
Ts = 1 / Fs
minFOFrenquency = 80
maxFOFrenquency = 300
minFOPeriod = 1 / minFOFrenquency
maxFOPeriod = 1 / maxFOFrenquency
Nbegin = round(maxFOPeriod / Ts)
Nend = round(minFOFrenquency / Ts)

y = np.cos(2 * np.pi * 300 * np.arange(0, 2 * Fs) * Ts)
plt.subplot(211)
plt.plot(Ts * np.arange(0, len(y)), y)
plt.xlabel("time(s)")
plt.ylabel("Signal y(t)")

R = sp.correlate(y, Nend, "full")
lags = sp.correlation_lags(np.size(y), np.size(y))
plt.subplot(212)
plt.plot(lags * Ts, R)
plt.xlabel("lag(s)")
plt.ylabel("Autocorrelation of y(t)")

pl.show
