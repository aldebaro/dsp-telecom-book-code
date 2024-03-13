import numpy as np
import matplotlib.pyplot as plt
import sincRec_fuction as sR

'''
Signal Reconstruction using SINC fuction
Illustrate perfect sinc reconstruction: ak_sinc_reconstruction(n, x, Ts,n_oversampled, xo, textra)

Inputs:
n - vector with integers as abscissa of x
x - samples of signal to be reconstructed
Ts - sampling interval (in seconds)
n_oversampled - vector with integers as abscissa of oversampled x
xo - oversampled x, to be used for comparison purposes
textra - extra time (in s) to be added for visualization purposes

Outputs:
x_reconstructed - reconstructed signal
x_parcels - matrix with individual sincs used in x_reconstructed
t_oversampled - discrete-time in seconds, corresponding to input n_oversampled 
multiplied by the oversampled Ts
t_oversampled_expanded - similar to t_oversampled but with 
the addition of textra in the beginning and end    
'''

# Define variables
max_n = 8  # n varies from -max_n to max_n
Ts = 0.2  # sampling interval (in seconds)
A = 4  # cosine amplitude, in Volts
Fs = 1 / Ts  # sampling frequency (5 Hz)
fc = Fs / 4  # cosine frequency (1.25 Hz)
oversampling_factor = 200  # oversampling factor
textra = 1 # one extra time (1 second) for visualizing sincs

# Generate signal xn sampled at Fs
n = np.arange(-max_n, max_n + 1)  # original discrete-time axis as integers
t = n * Ts  # original sampled time axis in seconds
xn = A * np.cos(2 * np.pi * fc * t)  # cosine sampled at Fs

# Generate oversampled version of xn
oversampled_Ts = Ts / oversampling_factor  # new value of Ts
oversampled_n = np.arange(int(n[0] * oversampling_factor), int(n[-1] * oversampling_factor) + 1)
oversampled_t = oversampled_n * oversampled_Ts  # time in seconds
oversampled_xn = A * np.cos(2 * np.pi * fc * oversampled_t)  # oversampled cosine


# Reconstruct signal from samples stored at xn and compare with
# the "ground truth" oversampled_xn
a=sR.ak_sinc_reconstruction(n, xn, Ts, oversampled_n, oversampled_xn, textra)
