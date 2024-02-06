import numpy as np
from scipy import signal
import matplotlib.pyplot as plt

bi = 7  # number of bits for integer part
bf = 8  # number of bits for decimal part
b = bi + bf + 1  # total number of bits, including sign bit
signed = 1  # use signed numbers (i.e., not "unsigned")

Bq = np.around(B, decimals=bf)  # quantize coefficients of B(z) using Q7.8
Aq = np.around(A, decimals=bf)  # quantize coefficients of A(z) using Q7.8

# Get the poles and zeros
zeros, poles, _ = signal.tf2zpk(Bq, Aq)

# Plot the poles and zeros
plt.figure()
plt.plot(np.real(zeros), np.imag(zeros), "o")
plt.plot(np.real(poles), np.imag(poles), "x")

# Add a unit circle for reference
unit_circle = plt.Circle((0, 0), 1, color="black", fill=False)
plt.gca().add_artist(unit_circle)

plt.title("Poles and Zeros")
plt.xlabel("Real")
plt.ylabel("Imaginary")
plt.axis("equal")
plt.grid()
plt.show()
