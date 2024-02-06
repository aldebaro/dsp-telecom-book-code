import numpy as np
import matplotlib.pyplot as plt

Fs = 0.5  # sampling frequency. Use a convenient value.
W = np.linspace(0, 3 * np.pi / 4, 100)  # digital frequencies in rad
w = 2 * Fs * np.tan(W / 2)  # analog (warped) frequencies in rad/s

plt.plot(W, w)
plt.xlabel(r'$\Omega$ (rad)')
plt.ylabel(r'$\omega$ (rad/s)')

# Same bandwidths in w (rad/s) lead to decreasing bands in W (rad)
deltaw = 0.4
w = 0.2 + np.arange(1, 7) * deltaw  # frequencies in w (rad/s)

print(f'b1,b2,b3={deltaw} rad/s (all have the same value)')

W = 2 * np.arctan(w / (2 * Fs))  # find the corresponding frequencies in W

print(f'B1,B2,B3={W[1]-W[0]}, {W[3]-W[2]}, {W[5]-W[4]} rad, respectively')

plt.show()
