import matplotlib.pyplot as plt
import numpy as np

Fs = 20  # Sampling Frequency
Ts = 1 / Fs  # Sampling Period
f0 = Fs / 2  # Frequency of a signal must be at maximun half of Sampling Freq.
t = np.arange(0, 1, Ts)  # Discrete time axis, 0 to 1 second
theta1 = np.pi / 4  # Define an angle
A1 = 1 / (np.cos(theta1))  # Define an amplitude
X1 = A1 * np.cos(
    2 * np.pi * f0 * t + theta1
)  # Define a cosine that does not obey the sampling theorem
theta2 = 0  # Define other angle, different from theta1
A2 = 1 / (np.cos(theta2))  # Define an mplitude
X2 = A2 * np.cos(
    2 * np.pi * f0 * t + theta2
)  # Define a cosine that does not obey the sampling theorem
plt.figure()
plt.title("Sampling theorem was not obeyed. Cannot distinguish the 2 signals!")
plt.plot(t, X1, "go-")
plt.plot(t, X2, "rx-")
plt.show()
