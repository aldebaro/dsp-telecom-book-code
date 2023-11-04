import matplotlib.pyplot as plt
import numpy as np
import pylab as pl
import scipy.signal as sp
from scipy.io.wavfile import write as wr

Fs = 44100  # sampling frequency
Ts = 1 / Fs  # sampling interval
minFOFrenquency = 80  # minimum F0 frequency in Hz
maxFOFrenquency = 300  # minimum F0 frequency in Hz
minFOPeriod = 1 / minFOFrenquency  # correponding F0 (sec)
maxFOPeriod = 1 / maxFOFrenquency  # correponding F0 (sec)
Nbegin = round(maxFOPeriod / Ts)  # number of lags for max freq.
Nend = round(minFOPeriod / Ts)  # number of lags for min freq.
# test with a cosine
y = np.cos(2 * np.pi * 300 * np.arange(0, 2 * Fs - 1) * Ts)  # 300 Hz, duration 2 secs
# Plot y
plt.subplot(211)
plt.plot(Ts * np.arange(0, len(y)), y)
plt.xlabel("time(s)")
plt.ylabel("Signal y(t)")

# ACF with max lag Nend
lags = plt.acorr(y, normed=False, maxlags=Nend)[0]  # Returning Lags
R = plt.acorr(y, normed=False, maxlags=Nend)[1] / len(y)  # returning R -> biased

firstIndex = np.where(lags == Nbegin)  # Find index of lag
Rpartial = R[firstIndex[0][0] :]  # Just the region of interest
Rmax = np.max(Rpartial)  # Max of Rpartial
relative_index_max = np.where(Rpartial == Rmax)
# Rpartial was just part of R, so recalculate the index
index_max = firstIndex + relative_index_max
lag_max = lags[index_max[0][0]]
# autocorrelation with normalized abscissa
plt.subplot(212)
plt.plot(lags * Ts, R)
plt.plot(lag_max * Ts, Rmax, "X")  # show the point
plt.xlabel("lag(s)")
plt.ylabel("Autocorrelation of y(t)")
plt.show()

F0 = 1 / (lag_max * Ts)  # estimated F0 frequency (Hz)
print(
    f"Rmax = {round(Rmax, 4)} lag_max= {round(lag_max, 4)} T= {round(lag_max*Ts, 4)}(s) Freq. = {F0} Hz\n"
)

# play freq. 3*F0
t = np.arange(0, 2, Ts)
aux = np.cos(2 * np.pi * 3 * F0 * t)
wr("Teste.wav", Fs, aux)  # Get the sample audio in the folder
