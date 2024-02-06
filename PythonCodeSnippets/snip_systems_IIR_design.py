import numpy as np
from scipy.signal import buttord, butter

# Normalized passband frequency (rad / pi)
Wp = 0.3
# Normalized stopband frequency (rad / pi)
Ws = 0.7
# Maximum passband ripple in dB
Rp = 1
# Minimum stopband attenuation in dB
Rs = 40

# Find the Butterworth order
n, Wn = buttord(Wp, Ws, Rp, Rs)
# Design the Butterworth filter
B, A = butter(3 * n, Wn)

# Z values at Wp and Ws
zp = np.exp(1j * np.pi * Wp)
zs = np.exp(1j * np.pi * Ws)

# Magnitude at Wp
linearMagWp = np.abs(np.polyval(B, zp) / np.polyval(A, zp))
# Magnitude at Ws
linearMagWs = np.abs(np.polyval(B, zs) / np.polyval(A, zs))

# Linear deviation at Wp (linear)
D_p = 1 - linearMagWp
# Deviation (ripple) at Wp (dB)
R_p = -20 * np.log10(1 - D_p)
# Linear deviation at Ws (linear)
D_s = linearMagWs
# Deviation (ripple) at Ws (dB)
R_s = -20 * np.log10(D_s)

print("Linear deviation at Wp (linear):", D_p)
print("Deviation (ripple) at Wp (dB):", R_p)
print("Linear deviation at Ws (linear):", D_s)
print("Deviation (ripple) at Ws (dB):", R_s)
