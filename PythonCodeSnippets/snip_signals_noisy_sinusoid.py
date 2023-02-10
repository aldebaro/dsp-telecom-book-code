import matplotlib.pyplot as plt
import numpy as np
import pylab as pl
from numpy import random as rd

A = 4  # sinusoid amplitude
noisePower = 25  # noise power
f = 2  # frequency in Hz
n = np.arange(0, 3999)  # discrete-time, using many samples to get good estimate
Fs = 20  # sampling frequency
x = A * np.sin(2 * np.pi * f / Fs * n)  # generate discrete-time sine
z = np.sqrt(noisePower) * rd.randn(np.size(x))  # generate noise

plt.figure()
plt.subplot(211)
plt.plot(x + z)

maxSample = 100  # determine the zoom range
plt.subplot(212)
plt.stem(x[1:maxSample] + z[1:maxSample])
pl.show()

maxlags = 20  # maximum lag for xcorr calculation
# signal only
Hx = plt.xcorr(x, x, usevlines=False, normed=False, maxlags=maxlags)
lx = Hx[0]
Rx = Hx[1]
Rx /= x.size - abs(lx)
# noise only
Hz = plt.xcorr(z, z, usevlines=False, normed=False, maxlags=maxlags)
lz = Hz[0]
Rz = Hz[1]
Rz /= z.size - abs(lz)
# noise signal
Hy = plt.xcorr(x + z, x + z, usevlines=False, normed=False, maxlags=maxlags)
ly = Hy[0]
Ry = Hy[1]
Ry /= (x + z).size - abs(ly)

plt.figure
plt.subplot(311)
plt.ylabel('R_x[l]')
plt.stem(lx, Rx)

plt.subplot(312)
plt.ylabel('R_z[l]')
plt.stem(lz, Rz)

plt.subplot(313)
plt.stem(ly, Ry)
plt.xlabel('Lag l')
pl.ylabel('R_y[l]')
pl.show()
