from scipy.signal import butter, lfilter, freqz, group_delay
import numpy as np
import matplotlib.pyplot as plt

# IIR filter
B, A = butter(8, 0.3)

# obtain h[n], truncated in 50 samples
t, h = impulse((B, A), N=50)

# plots the group delay of the filter
w, gd = group_delay((B, A))
plt.figure()
plt.plot(w, gd)
plt.title("Group delay")

# input signal to be filtered, in Volts
x = np.concatenate((np.arange(1, 21), np.arange(20, 0, -1)))

# FFT of x, to be read in Volts
X = np.fft.fft(x) / len(x)

# convolution y=x*h
y = np.convolve(x, h)
