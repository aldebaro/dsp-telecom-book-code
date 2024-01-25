import numpy as np

zeta = 0.5  # damping ratio, e.g. sqrt(2)/2 = 0.707
wn = 2  # natural frequency in rad/s
epsilon = 0.05  # tolerance for the settling time (5% in this case)
tp_factor = np.pi / np.sqrt(1 - zeta**2)  # depends on zeta only
tp = tp_factor / wn  # peak time
tr_factor = (2.23 * zeta**2 - 0.078 * zeta + 1.12) / np.sqrt(
    1 - zeta**2
)  # zeta only
tr = tr_factor / wn  # rise time
ts_factor = -np.log(epsilon * np.sqrt(1 - zeta**2)) / zeta  # zeta only
ts = ts_factor / wn  # settling time
ov = np.exp(
    -(zeta * np.pi) / np.sqrt(1 - zeta**2)
)  # overshoot (depends on zeta only)
bw_factor = np.sqrt(
    1 - 2 * zeta**2 + np.sqrt(2 - 4 * zeta**2 + 4 * zeta**4)
)  # zeta only
wc = wn * bw_factor  # cutoff frequency=3-dB bandwidth (in radians/second)

# Check whether the cutoff frequency wc corresponds to a -3 dB gain
s = 1j * wc  # define s = j wc
Hs = (wn**2) / (s**2 + 2 * zeta * wn * s + (wn**2))  # system function
gain_at_wc = 20 * np.log10(abs(Hs))  # answer is -3.0103 dB
