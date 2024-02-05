import numpy as np
import matplotlib.pyplot as plt
import scipy
import PyDynamic

# sampling period
Ts = 0.5

# Define H(s)=Bs/As
Bs = 4
As = np.poly([-2, -3])

# impulse invariance conversion to H(z)
[Bz, Az] = PyDynamic.misc.impinvar(Bs, As, 1 / Ts)
Bz = np.concatenate((Bz, np.zeros(1)))

# create h(t) to compare
t = np.arange(0, 10 + Ts, Ts)  # time vector
ht = 4 * (np.exp(-2 * t) - np.exp(-3 * t))

# discrete-time h[n] from H(z)=Bz/Az (dlti => discrete linear time invariant)
_, hn = scipy.signal.dlti(Bz, Az).impulse(n=ht.size)
hn = np.squeeze(hn)

# error from column vectors
h_Error = Ts * ht - hn
print(f"mean square error (MSE) = {np.mean(h_Error**2)}")

# compare curves
plt.plot(t, Ts * ht, label=r"$T_s \times h(t)$")
plt.plot(t, hn, "rx", label=r"$h(nT_s)$ that has same amplitudes of $h[n]$")
plt.legend()
plt.xlabel("time (s)")
plt.show()
