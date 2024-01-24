import numpy as np
from scipy import signal as scp

wn = 2  # natural frequency in rad/s
zeta = 0.5  # damping ratio
Fs = 10 * wn / (2 * np.pi)  # Fs chosen as 10 times the natural freq. in Hz
Wn = wn * (1 / Fs)  # convert angular freq. from continuous to discrete-time
if True:
    Bz, Az = scp.bilinear(
        wn**2, [1, 2 * zeta * wn, (wn**2)], Fs
    )  # to compare below
    Bz2 = np.multiply((Wn**2), [1, 2, 1])  # expression from this textbook
    Az2 = [
        4 + 4 * zeta * Wn + (Wn**2),
        2 * (Wn**2) - 8,
        4 - 4 * zeta * Wn + (Wn**2),
    ]  # from textbook

else:
    [Bz, Az] = scp.bilinear(
        [2 * zeta * wn, wn ^ 2], [1, 2 * zeta * wn, wn ^ 2], Fs
    )  # compare
    Bz2 = [4 * zeta * Wn + Wn ^ 2, 2 * Wn ^ 2, Wn * (Wn - 4 * zeta)]
    # from textbook
    Az2 = [
        4 + 4 * zeta * Wn + Wn ^ 2,
        2 * Wn ^ 2 - 8,
        4 - 4 * zeta * Wn + Wn ^ 2,
    ]  # from textbook

# normalize as done by bilinear
Bz2 = np.multiply(Bz2, 1 / Az2[0])
print(Bz2)
Az2 = np.multiply(Az2, 1 / Az2[0])
print(Az2)
