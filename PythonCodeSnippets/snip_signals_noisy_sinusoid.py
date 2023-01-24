import matplotlib.pyplot as plt
import numpy as np
import pylab as pl
import scipy.signal as sp
from numpy import random as rd

A = 4  # sinusoid amplitude
noisePower = 25  # noise power
f = 2  # frequency in Hz
n = np.arange(0, 4000)  # Discrete_time
Fs = 20  # sampling frequency
x = A * np.sin(2 * np.pi * f / Fs * n)  # generate discrete_time sine
z = np.sqrt(noisePower) * rd.randn(np.size(x))  # generate noise
plt.figure()
plt.subplot(211)
plt.stem(x + z)
maxSample = 100  # determine the zoom range
plt.subplot(212)
plt.stem(x[0:maxSample] + z[0:maxSample])
pl.show()

maxlags = 20  # maximum lag for acorr calculation
# acor signal only
Hx = plt.xcorr(x, x, usevlines=False, normed=False, maxlags=maxlags)
lx = Hx[0]
Rx = Hx[1]
Rx /= x.size - abs(lx)
# acor noise only
Hz = plt.xcorr(z, z, usevlines=False, normed=False, maxlags=maxlags)
lz = Hz[0]
Rz = Hz[1]
Rz /= z.size - abs(lz)
# acor noise signal
Hy = plt.xcorr(x + z, x + z, usevlines=False, normed=False, maxlags=maxlags)
ly = Hy[0]
Ry = Hy[1]
Ry /= (x + z).size - abs(ly)

plt.figure
plt.subplot(311)
plt.stem(lx, Rx / 2500)

plt.subplot(312)
plt.stem(lz, Rz / 5000)

plt.subplot(313)
plt.stem(ly, Ry / 4000)

pl.show()
