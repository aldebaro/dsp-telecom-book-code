import numpy as np
from scipy import signal

B = np.array([0.6, 0.1, 2.3, 4.5])  # numerator
A = np.array([1, -1.2, 0.4, 5.2, 1.1])  # denominator

z, p, k = signal.tf2zpk(B, A)  # convert to zero-pole
sos = signal.zpk2sos(z, p, k)  # to SOS

print("Zeros:", z)
print("Poles:", p)
print("Gain:", k)
print("Second-Order Sections:", sos)
