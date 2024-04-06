'''
References:
https://docs.scipy.org/doc/scipy/reference/generated/scipy.signal.firls.html
'''
from scipy.signal import freqz, firls
from matplotlib import pyplot as plt
import numpy as np

f = np.array([[0, 0.25], [0.3, 0.55], [0.6, 0.85], [0.9, 1]]) # frequencies
A = np.array([[1, 1], [0, 0], [1, 1], [0, 0]]) # desired amplitudes
M = 70  # filter order
numtaps = M+1  # number of taps, which is the FIR order plus 1. Needs to be odd
W = [1000, 1, 1, 1]  # weights, first passband is prioritized

B = firls(numtaps, f, A, weight=W)  # Design FIR filter using firls
w, Hz = freqz(B)  # Compute discrete-time frequency response
plt.plot(w,np.abs(Hz)) # plot the magnitude
