import numpy as np
import matplotlib.pyplot as plt

power = 8  # Watts
N = 10000  # number of samples
x = np.sqrt(power) * np.random.randn(N)  # white noise signal
Fs = 40
maxLag = 100  # maximum lag

# Biased autocorrelation
R, l = np.correlate(x, x, mode='full')[-N:], np.arange(0, N)

plt.stem(l, R)
plt.xlabel('lag l')
plt.ylabel('autocorrelation R[l]')
plt.title('Autocorrelation of white noise')
# Set specific limits for x and y axes
plt.xlim([-100, 100])
plt.ylim([-1, 8])

plt.show()
