import numpy as np
from scipy.signal import firwin, hamming

Fs = 44100  # sampling freq. (all freqs. in Hz)
N = 100  # filter order (N+1 coefficients)
Fc1 = 8400  # First cutoff frequency
Fc2 = 13200  # Second cutoff frequency

# Calculate the normalized cutoff frequencies
Wn = np.array([Fc1, Fc2]) / (Fs / 2)

# Generate the FIR filter coefficients using the 'stop' method and Hamming window
B = firwin(N+1, Wn, pass_zero='bandstop', window='hamming')

# B is the resulting filter coefficients

print(B)