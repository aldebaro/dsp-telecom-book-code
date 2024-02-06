import numpy as np
from numpy.fft import fft

N = 32  # Number of DFT-points

n = np.arange(N)  # Abscissa to generate signal below
x = (
    2
    + 3 * np.cos(2 * np.pi * 6 / 32 * n)
    + 8 * np.sin(2 * np.pi * 12 / 32 * n)
    - +4 * np.cos(2 * np.pi * 7 / 32 * n)
    + 6 * np.sin(2 * np.pi * 7 / 32 * n)
)
X = fft(x) / N  # Calculate DTFS spectrum via DFT

X[abs(X) < 1e-12] = 0  # Mask numerical errors
