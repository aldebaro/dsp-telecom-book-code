import numpy as np
import matplotlib.pyplot as plt

sigma = -0.3
w = 2 * np.pi * 5  # Frequency of 5 Hz

z = -sigma + 1j * w  # Define a complex variable z

t = np.linspace(0, 3, 1000)  # Interval from [0, 3] sec.

x = np.exp(z * t)  # The signal

envelope = np.exp(-sigma * t)  # The signal envelope

plt.subplot(121)
plt.plot(t, np.real(x))
plt.plot(t, envelope, ":r")
plt.show()
