import numpy as np
from scipy.signal import lfilter, lfilter_zi
from spectrum import aryule

N = 100
x = np.random.randn(N)  # WGN witch mean and unit variance
y = lfilter([4], [1, 0.5, 0.98], x)  # realization of an AR(2) process

Py = np.mean(y**2)  # signal power

A, Perror, _ = aryule(y, 2)  # estimate the filter via LPC

# impulse response of 1/A(z)
zi = lfilter_zi([1], A)
z, _ = lfilter([1], A, np.concatenate(([1], np.zeros(499))), zi=zi * 1)

Eh = np.sum(z**2)  # impulse response energy

print("Py = ", Py)
print("A = ", A)
print("Perror = ", Perror)
print("Eh = ", Eh)
print(Py - (Perror * Eh))
