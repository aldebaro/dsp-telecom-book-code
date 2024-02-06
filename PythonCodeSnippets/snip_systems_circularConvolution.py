import numpy as np
from scipy.signal import convolve

# Signals to be convolved
x = np.array([1, 2, 3, 4])
h = np.array([0.9, 0.8])

# Deciding whether to make linear and circular convolution equivalent
shouldMakeEquivalent = 1

# Determining the size for zero-padding
if shouldMakeEquivalent == 1:
    N = (
        len(x) + len(h) - 1
    )  # To force the match between linear and circular convolution
else:
    N = max(len(x), len(h))  # Necessary for FFT zero-padding

# Linear convolution
linearConv = convolve(x, h, mode="full")

# Circular convolution using FFT
x_padded = np.fft.fft(x, n=N)
h_padded = np.fft.fft(h, n=N)
circularConv = np.fft.ifft(x_padded * h_padded)

print("shouldMakeEquivalent =\n", shouldMakeEquivalent)
print("\nlinearConv =\n", linearConv)
print(
    "\ncircularConv =\n", np.real(circularConv)
)  # The real part is shown, ignoring the small imaginary part
