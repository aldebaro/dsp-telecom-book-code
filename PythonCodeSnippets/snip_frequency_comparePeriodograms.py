import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import periodogram

N = 1024
n = np.arange(N)  # Column vector in MATLAB, but numpy makes no distinction
A = 10
x = A * np.cos((2 * np.pi / 64) * n)  # Generates cosine with period 64

BW = 2 * np.pi  # Assumed bandwidth
S = np.abs(np.fft.fft(x)) ** 2 / (BW * N)  # Periodogram

# Avoids zero-padding in the periodogram:
Nfft = N
f, H = periodogram(x, fs=BW, nfft=Nfft, scaling="density")

Power = np.sum(H) * BW / N  # Power from unilateral periodogram
Power2 = np.sum(S) * BW / N  # Power from bilateral periodogram

# Conversion from bilateral to unilateral:
Sunilateral = np.concatenate(([S[0]], 2 * S[1 : N // 2], [S[N // 2]]))

print(f"Power from unilateral periodogram: {Power}")
print(f"Power from bilateral periodogram: {Power2}")

# Comparison of periodograms
plt.plot(f, H, "-o", label="Periodogram")
plt.plot(f, Sunilateral, "-x", label="Bilateral to Unilateral Conversion")
plt.legend()
plt.show()
