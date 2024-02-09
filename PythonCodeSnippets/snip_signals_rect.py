import numpy as np
import matplotlib.pyplot as plt

# Custom function to mimic MATLAB's rectpuls
def rectpuls(t, width):
    return np.where(np.abs(t) <= width / 2, 1, 0)

# Mimicking a continuous-time signal by using plot
Ts = 0.001  # Sampling interval in seconds
t = np.arange(-0.8, 0.8 + Ts, Ts)  # Discrete-time in seconds
pulse_width = 0.2  # Support of this rect in seconds
tc = 0.4  # Center (in seconds) of this rect
A = 2.5  # Amplitude (in Volts) of this rect
x = A * rectpuls(t - tc, pulse_width)

plt.subplot(2, 1, 1)
plt.plot(t, x)  # Plot as a continuous-time signal
plt.xlabel('t')
plt.ylabel('x(t)')

# Making explicit the signal is discrete-time by using stem
n = np.arange(-10, 11)  # Discrete-time in seconds
pulse_width = 5  # Support of this rect in samples
nc = -3  # Center (in samples) of this rect
A = 7  # Amplitude (in Volts) of this rect
x = A * rectpuls(n - nc, pulse_width)

plt.subplot(2, 1, 2)
plt.stem(n, x)  # Plot as a discrete-time signal
plt.xlabel('n')
plt.ylabel('x[n]')

plt.show()