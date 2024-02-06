import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

# # Illustrates the step invariance method to convert a single pole H(s)
Ts = 0.5  # taxa de amostragem
a = 10  # polo
Bs = a
As = [1, a]

# Note the delay z^{-1} in Bz below to align u[n] with u(t).
# Try using Bz = [1 - np.exp(-a * Ts)] instead.
Bz = [0, 1 - np.exp(-a * Ts)]
Az = [1, -np.exp(-a * Ts)]

t = np.arange(0, 10 + Ts, Ts)
qt = 1 - np.exp(-a * t)  # q(t) is the system response to u(t)

un = np.ones(2 * len(t))

# Converting the transfer function to
# state space to use with dimpulse
s1 = signal.dlti(Bz, Az, dt=Ts)
t, hn = signal.dimpulse(s1, n=len(t))

hn = hn[0][:, 0]

qn = np.convolve(un, hn, mode="full")[: len(t)]
q_Error = qt - qn

print(f"mean square error (MSE) = {np.mean(q_Error**2)}")

plt.plot(t, qt)
plt.plot(t, qn, "rx")  # comparar curvas
plt.legend(["q(t)", "q[n]"])
plt.xlabel("time (s)")
plt.show()
