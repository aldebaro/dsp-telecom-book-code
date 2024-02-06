import matplotlib.pyplot as plt
import numpy as np

D = np.array([13, 126, 3, 34, 254])  # signal as 8-bits unsigned [0, 255]
n = np.arange(5)  # sample instants in the digital domain
Fs = 8000  # sampling frequency
delta = 0.78e-3  # step size in Volts
A = (D - 128) * delta  # subtract offset=128 and normalize by delta
Ts = 1 / Fs  # sampling interval in seconds
time = n * Ts  # normalize abscissa

plt.stem(time, A)  # compare with stem(n,D)
plt.xlabel('time (s)')
plt.ylabel('amplitude (V)')
plt.show()
