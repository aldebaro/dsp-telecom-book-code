import matplotlib.pyplot as plt
import numpy as np
from scipy.special import sinc

Ts = 0.001  # sampling interval (in seconds)
xi = 0.2  # support of the sinc in seconds
gamma = 0.5  # time shift
t = np.arange(-1.6, 1.6+Ts, Ts)  # define discrete-time axis with fine resolution
x = 3 * sinc((t - gamma) / xi)  # define the signal x(t)
plt.plot(t, x)
plt.show()