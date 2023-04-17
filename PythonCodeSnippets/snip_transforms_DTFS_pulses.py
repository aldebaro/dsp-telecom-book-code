import numpy as np
from numpy.fft import fft

# Define durations and k
N = 10
N1 = 5
k = np.arange(N)
            
# Obtain DTFS directly
Xk = (
    (1 / N)
    * (np.sin(k * N1 * np.pi / N) / np.sin(k * np.pi / N))
    * np.exp(-1j * k * np.pi / N * (N1 - 1))
)
Xk[0] = N1 / N  # Eliminate the NaN (not a number) in Xk[0]

# Second alternative, via DFT. Generate x[n]:
xn = np.concatenate((np.ones(N1), np.zeros(N - N1)))  # Single period of x[n]
Xk2 = fft(xn) / N  # DTFS via DFT, Xk2 is equal to Xk
