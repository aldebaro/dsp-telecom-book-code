import numpy as np
import matplotlib.pyplot as plt

sigma = -0.3

w = 2 * np.pi * 5  # Frequency of 5 Hz

z = -sigma + 1j * w  # Define a complex variable z
z2 =  sigma + 1j * w  # Define a complex variable z

t = np.linspace(0, 3, 1000)  # Interval from [0, 3] sec.

x = np.exp(z * t)  # The signal
x2 = np.exp(z2 * t)  # The signal


envelope = np.exp(-sigma * t)  # The signal envelope
envelope2 = np.exp(sigma*t)

plt.subplot(121)
plt.plot(t, np.real(x), label = r'$e^{st}$')
plt.plot(t, envelope, ":r", label = r'$e^{-\sigma t}$')
plt.xlabel("t(s)")
plt.ylabel(r'Real{$(e^s)$}')
plt.legend()

plt.subplot(122)
plt.plot(t, np.real(x2),label = r'$e^{st}$')
plt.plot(t, envelope2, ":r", label = r'$e^{\sigma t}$')
plt.xlabel("t(s)")
plt.ylabel(r'Real{$(e^s)$}')
plt.legend()

plt.subplots_adjust(wspace=0.6, hspace=0.6)
plt.show()
