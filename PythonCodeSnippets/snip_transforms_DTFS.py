import numpy as np
from numpy.fft import fft
from lasse.transforms.dft import ak_fftmtx

N = 12# Period in samples
n = np.arange(N)  # Column vector representing abscissa
Vp = 10
x = Vp * np.cos(np.pi / 6 * n + np.pi / 3)# Cosine with amplitude 10 V
X = (1 / N) * fft(x)# Calculate DFT and normalize to obtain DTFS
A = ak_fftmtx(N, 2)[0]# DFT matrix with the DTFS normalization
X2 = np.dot(A, x)# Calculate the DTFS via the normalized DFT matrix

