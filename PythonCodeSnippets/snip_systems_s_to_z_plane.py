import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

# Set parameters
chebyshev_filter_type = 1  # 1 has ripple in passband, 2 in stopband
filter_order = 4  # H(s) filter order
z_to_s_mapping = "s = z * Fs"  # some transformation

if chebyshev_filter_type == 1:
    w_filter = 8  # passband frequency (rad/s)
    passband_ripple = 1  # maximum ripple in passband (dB)
    Bs, As = signal.cheby1(filter_order, passband_ripple, w_filter, analog=1)
elif chebyshev_filter_type == 2:
    w_filter = 15  # stopband frequency (rad/s)
    stopband_ripple = 40  # ripple down from the peak passband value (dB)
    Bs, As = signal.cheby2(filter_order, stopband_ripple, w_filter, analog=1)

Fs = (20 * w_filter) / (2 * np.pi)  # choose sampling frequency (Hz)

# Plot H(s) and the corresponding H(z)
slim = 20
aux1 = np.linspace(-slim, slim, 100)
Xs, Ys = np.meshgrid(aux1, aux1)
s = Xs + 1j * Ys
Hs = np.divide(np.polyval(Bs, s), np.polyval(As, s))

zlim = 10
Xz, Yz = np.meshgrid(
    np.linspace(-zlim, zlim, 100) / Fs, np.linspace(-zlim, zlim, 100) / Fs
)
z = Xz + 1j * Yz

# for each point z at Z plane, find s and the corresponding value H(s)
# s = (2 * Fs * (z - 1)) / (z + 1)  # use bilinear transformation
exec(z_to_s_mapping)  # for each z, find the corresponding s
Hz = np.divide(np.polyval(Bs, s), np.polyval(As, s))

# Plot in dB
fig1 = plt.figure(1)
ax1 = fig1.add_subplot(111, projection="3d")
ax1.plot_surface(Xs, Ys, 20 * np.log10(np.abs(Hs)), cmap="viridis")
ax1.set_xlabel("Re{s} (σ)")
ax1.set_ylabel("Im{s} (jω)")
ax1.set_zlabel("20 log10 |H(s)|")

fig2 = plt.figure(2)
ax2 = fig2.add_subplot(111, projection="3d")
ax2.plot_surface(Xz, Yz, 20 * np.log10(np.abs(Hz)), cmap="viridis")
ax2.set_xlabel("Re{z}")
ax2.set_ylabel("Im{z}")
ax2.set_zlabel("20 log10 |H(z)|")

# The frequency responses
fig3, (ax3, ax4, ax5) = plt.subplots(3, 1, figsize=(8, 12))

# H(s) is in fact H(jw) here
s_w = 1j * np.linspace(-slim, slim, 100)
Hs_w = np.divide(np.polyval(Bs, s_w), np.polyval(As, s_w))
ax3.plot(np.imag(s_w), 20 * np.log10(np.abs(Hs_w)))
ax3.set_xlabel("ω (rad/s)")
ax3.set_ylabel("20 log10 |H(jω)|")

# find the mapping from s to Z over the imaginary axis of Z
z_w = 1j * np.linspace(-np.pi, np.pi, 100)
exec(z_to_s_mapping)
Hz_new_w = np.divide(np.polyval(Bs, s), np.polyval(As, s))
ax4.plot(np.imag(z_w), 20 * np.log10(np.abs(Hz_new_w)))
ax4.set_xlabel("Im{z}")
ax4.set_ylabel("20 log10 |H(Im{z})|")

# find the mapping from s to Z over the unit circle
z_W = np.exp(1j * np.linspace(-np.pi, np.pi, 100))
exec(z_to_s_mapping)
Hz_W = np.divide(np.polyval(Bs, s), np.polyval(As, s))
ax5.plot(np.angle(z_W), 20 * np.log10(np.abs(Hz_W)))
ax5.set_xlabel("Ω (rad)")
ax5.set_ylabel("20 log10 |H(e^{jΩ})|")

plt.tight_layout()
plt.show()
