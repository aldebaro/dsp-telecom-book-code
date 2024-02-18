import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import butter, convolve, lfilter

# Input signal to be filtered, in Volts
x = np.concatenate((np.arange(1, 21), np.arange(20, 0, -1)))
B, A = butter(8, 0.3)  # IIR filter

# Calculate the impulse response of the filter
impulse = np.zeros(50)
impulse[0] = 1
h = lfilter(B, A, impulse)  # truncate h[n] using 50 samples
y = convolve(x, h, mode="full")  # convolution y=x*h

# Force x and y to be column vectors
x = x[:, np.newaxis]
y = y[:, np.newaxis]

meanGroupDelay = 5  # estimated "best" filter delay
y = y[meanGroupDelay:]  # compensate the filter delay
y = y[: len(x)]  # eliminate the convolution tail
mse = np.mean((x - y) ** 2)  # calculate the mean squared error

# Estimate signal/noise ratio
SNR = 10 * np.log10(np.mean(x.astype(float) ** 2) / mse.astype(float))

# Plot the input, output, and error
plt.stem(np.arange(len(x)), x, linefmt="b-", markerfmt="bo", basefmt=" ")
plt.stem(np.arange(len(y)), y, linefmt="r-", markerfmt="ro", basefmt=" ")
plt.stem(np.arange(len(y)), x - y, linefmt="k-", markerfmt="ko", basefmt=" ")
plt.show()
