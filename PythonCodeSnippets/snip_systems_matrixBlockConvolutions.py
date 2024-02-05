import numpy as np
from scipy.linalg import toeplitz
from scipy.signal import convolve
import matplotlib.pyplot as plt

x = np.arange(1, 1001)  # (eventually long) input signal
h = np.ones(3)  # non-zero samples of finite-length impulse response
Nh = len(h)  # number of impulse response non-zero samples
Nb = 5  # block (segment) length
Nbout = Nb + Nh - 1  # number of samples at the output of each block
Nx = len(x)  # number of input samples

# impulse response in matrix notation
hmatrix = toeplitz(np.concatenate([h, np.zeros(Nb - 1)]), np.zeros(Nb))

y = np.zeros(Nh + Nx - 1)  # pre-allocate space for convolution output

for beginNdx in range(0, Nx, Nb):  # loop over all blocks
    endIndex = beginNdx + Nb  # current block end index
    xblock = x[beginNdx:endIndex]  # block samples
    yblock = hmatrix @ xblock  # perform convolution for this block
    y[beginNdx:beginNdx + Nbout] += yblock  # add partial result

# compare the error with result from conv
plt.plot(y - convolve(x, h, mode='full'))
plt.show()  