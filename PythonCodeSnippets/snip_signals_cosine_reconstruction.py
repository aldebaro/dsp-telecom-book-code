import numpy as np
import matplotlib.pyplot as plt

# Define variables
max_n = 8  # n varies from -max_n to max_n
Ts = 0.2  # sampling interval (in seconds)
A = 4  # cosine amplitude, in Volts
Fs = 1 / Ts  # sampling frequency (5 Hz)
fc = Fs / 4  # cosine frequency (1.25 Hz)
oversampling_factor = 200  # oversampling factor
textra = 1  # one extra time (1 second) for visualizing sincs

# Generate signal xn sampled at Fs
n = np.arange(-max_n, max_n + 1)  # original discrete-time axis as integers
t = n * Ts  # original sampled time axis in seconds
xn = A * np.cos(2 * np.pi * fc * t)  # cosine sampled at Fs

# Generate oversampled version of xn
oversampled_Ts = Ts / oversampling_factor  # new value of Ts
oversampled_n = np.arange(int(n[0] * oversampling_factor), int(n[-1] * oversampling_factor) + 1)
oversampled_t = oversampled_n * oversampled_Ts  # time in seconds
oversampled_xn = A * np.cos(2 * np.pi * fc * oversampled_t)  # oversampled cosine

def ak_sinc_reconstruction(n, x, Ts, t_oversampled, xo, t_oversampled_expanded, x_reconstructed, x_parcels):
    # Add your plotting code here
    pass

# Reconstruct signal from samples stored at xn and compare with
# the "ground truth" oversampled_xn
ak_sinc_reconstruction(n, xn, Ts, oversampled_n, oversampled_xn, textra)
