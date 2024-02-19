from scipy.signal import ellip

N = 5  # filter order for the lowpass prototype (e.g., bandpass is 2*N)
Rp = 0.1  # maximum ripple in passband (dB)
Rs = 30  # minimum attenuation in stopband (dB)

# Highpass filter, cutoff=0.4 rad
B_high, A_high = ellip(N, Rp, Rs, 0.4, btype="highpass")

# Bandpass filter, BW=[0.5, 0.8], order=2*N
B_bandpass, A_bandpass = ellip(N, Rp, Rs, [0.5, 0.8], btype="bandpass")

# Stopband filter, BW=[0.5, 0.8], order=2*N
B_stop, A_stop = ellip(N, Rp, Rs, [0.5, 0.8], btype="bandstop")

# Display coefficients
print("Highpass Filter Coefficients:")
print("B:", B_high)
print("A:", A_high)

print("\nBandpass Filter Coefficients:")
print("B:", B_bandpass)
print("A:", A_bandpass)

print("\nStopband Filter Coefficients:")
print("B:", B_stop)
print("A:", A_stop)
