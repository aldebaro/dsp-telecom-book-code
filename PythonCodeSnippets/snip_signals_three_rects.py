import numpy as np
import matplotlib.pyplot as plt

def rectpuls(t, width):
    """Generates a rectangular pulse with specified width."""
    return np.where(np.abs(t) <= width / 2, 1, 0)

# Sampling interval in seconds
Ts = 0.001
# Discrete time in seconds
t = np.arange(-1.6, 1.6, Ts)
# Support width of this rectangle in seconds
pulse_width = 0.2
# Defines the signal
x = (
    rectpuls(t, pulse_width)
    - 3 * rectpuls(t - 0.2, pulse_width)
    + 3 * rectpuls(t - 0.4, pulse_width)
)
# Plots as a continuous signal
plt.plot(t, x)
plt.xlabel("t")
plt.ylabel("x(t)")
plt.show()
