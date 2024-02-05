import numpy as np
from scipy.signal import butter, lfilter
from fixedpoint import FixedPoint

# Set parameters
N = 100  # Number of samples
x = 20 * np.random.randn(N)  # generate random samples
M = 4  # Filter order

B, A = butter(M, 0.3)  # Design IIR filter

# Define FixedPoint-point elements
bi = 3  # Number of bits for integer part
bf = 5  # Number of bits for fractional part

# Quantize the input
xf = np.array(
    [float(FixedPoint(i, signed=True, m=bi, n=bf,
                      overflow_alert="ignore")) for i in x]
)

# Quantize the filter's numerator and denominator
Bf = np.array(
    [float(FixedPoint(b, signed=True, m=bi, n=bf,
                      overflow_alert="ignore")) for b in B]
)
Af = np.array(
    [float(FixedPoint(a, signed=True, m=bi, n=bf,
                      overflow_alert="ignore")) for a in A]
)

y1 = lfilter(B, A, x)  # Output with ("infinite") double precision
y2 = lfilter(Bf, Af, x)  # Quantized: only filter coefficients
y3 = lfilter(Bf, Af, xf)  # Quantized: input and coefficients
y4 = lfilter(B, A, xf)  # Quantized: only input

# Quantized: input, output, and coefficients
y5 = np.array(
    [float(FixedPoint(i, signed=True, m=bi, n=bf,
                      overflow_alert="ignore")) for i in y1]
)
