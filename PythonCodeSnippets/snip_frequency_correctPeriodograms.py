import numpy as np
from scipy.signal import periodogram
from numpy.fft import fftshift

# Defining variables
N = 1024
n = np.arange(N)  # Column vector n
A = 10
x = A * np.cos((2 * np.pi / 64) * n)  # Generating cosine with period 64
Fs = 500  # Fs = BW = 500 Hz
BW = Fs

# Unilateral periodogram
f, H = periodogram(x, Fs, nfft=N, return_onesided=True)

# Bilateral periodogram with frequency range adjustment
f2, H2 = periodogram(x, Fs, nfft=N, return_onesided=False)
# Adjusting the frequency range to [0, Fs) using fftshift
H2 = fftshift(H2)
f2 = np.linspace(0, Fs, N, endpoint=False)

# Power for the unilateral periodogram
Power = (BW / N) * np.sum(H)

# Power for the bilateral periodogram
Power2 = (BW / N) * np.sum(H2)

print(f"Power = {Power}")
print(f"Power2 = {Power2}")
print(f"ans = {f[-1]}")
print(f"ans = {f2[-1]}")
print(f"ans = {len(f)}")
print(f"ans = {len(f2)}")
