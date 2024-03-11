import numpy as np
from scipy.signal import correlate, convolve

# Define some complex signals as row vectors
x = (np.arange(1, 5) + 1j * np.arange(4, 0, -1)).reshape(1, -1)
y = np.random.rand(1, 15) + 1j * np.random.rand(1, 15)

# Correlation via convolution
Rref = correlate(x, y)
xcorrViaConv = convolve(x, np.conj(np.fliplr(y)))  # fliplr inverts the ordering

# Convolution via correlation
Cref = convolve(x, y)
convViaXcorr = correlate(x, np.conj(np.fliplr(y)))  # fliplr inverts the ordering
# convViaXcorr= np.conj(np.fliplr(correlate(np.conj(np.fliplr(x)),y))) # alternative

# Calculate maximum errors
ErroXcorr = np.max(np.abs(Rref - xcorrViaConv))  # calculate maximum errors
ErroConv = np.max(np.abs(Cref - convViaXcorr))  # should be small numbers

print(f"Maximum error for cross-correlation: {ErroXcorr:.5e}")
print(f"Maximum error for convolution: {ErroConv:.5e}")
