import numpy as np
import matplotlib.pyplot as plt
from scipy.fft import fft, ifft

# Infinite duration (or "long") input signal
x = np.arange(1, 1001)

# Non-zero samples of finite-length impulse response
h = np.ones(3)

# Number of impulse response non-zero samples
Nh = len(h)

# Block (segment) length
Nb = 5

# Choose a power of 2 FFT size
Nfft = 2 ** np.ceil(np.log2(Nh + Nb - 1)).astype(int)

# Number of input samples
Nx = len(x)

# Pre-compute impulse response DFT, with zero-padding
H = fft(h, Nfft)

# Initialize index for first sample of current block
begin_index = 0

# Pre-allocate space for convolution output
y = np.zeros(Nh + Nx - 1)

# Loop over all blocks
while begin_index < Nx:
    end_sample = min(begin_index + Nb, Nx)  # Last sample of current block
    Xblock = fft(x[begin_index:end_sample], Nfft)  # DFT of block
    yblock = ifft(Xblock * H, Nfft)  # Get circular convolution result
    output_index = min(begin_index + Nfft, Nh + Nx - 1)  # Auxiliary variable
    # Add partial result, ensuring to only use the real part of the complex numbers
    y[begin_index:output_index] += yblock[:output_index - begin_index].real
    begin_index += Nb  # Shift beginning of block


# Compare the error with result from conv
error = y - np.convolve(x, h, mode='full')
plt.stem(error)
plt.show()