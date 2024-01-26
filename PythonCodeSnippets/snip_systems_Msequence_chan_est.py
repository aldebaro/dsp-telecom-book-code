import numpy as np
from scipy.signal import max_len_seq

h = np.transpose([-4+1j, -3, -2-1j])  # channel, column vector
Nh = len(h)  # channel impulse response length
Nx = 15  # number of samples of training sequence

# training sequence (a maximum length sequence)
x = max_len_seq(
                4,
                taps=[3]
                )[0]*2-1

alpha = 1/np.sum(x**2)  # 1/alpha is the value of autocorrelation R(0)
y = np.convolve(h, x)  # input signal passes through the channel

# Channel estimation and synchronization
z = np.convolve(y, np.flipud(x))  # use convolution to mimic correlation, or
# alternatively, one could use z=xcorr(y,conj(x)); and to make exactly
# equivalent to conv extract part of result: z=z(end-2*Nx-Nh+3:end);
max_output = np.max(np.abs(z))  # find peak of output (R)
max_index = np.argmax(np.abs(z))  # find the index of output (R)
h_est = alpha*z[max_index: max_index+Nh]  # estimated channel (postcursor)
MSE = np.mean(np.abs(h-h_est)**2)  # estimation error
NMSE = 10*np.log10(MSE/np.mean(np.abs(h)**2))  # normalized MSE in dB

# Compare with theoretical values
R = np.correlate(x, x, "full")  # autocorrelation
z2 = np.convolve(R, h)  # conceptually, this is what we are doing to get z
z_error = np.max(np.abs(z - z2))  # note that z is equal to z2

print(f'Original channel: {h}')
print(f'Estimated channel: {h_est}')
print(f'NMSE (dB): {NMSE} dB')
print(f'Z error: {z_error}')
