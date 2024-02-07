import numpy as np
import matplotlib.pyplot as plt

N = 300  # number of samples and FFT size
power_x = 600  # desired noise power in Watts
Fs = 1  # sampling frequency = BW = 1 Hertz

# Gaussian white noise
x = np.sqrt(power_x) * np.random.randn(N)

# Actual obtained power
actual_power = np.mean(x**2)
print(f'The actual obtained power: {actual_power}')

# Periodogram
Sk, F = plt.psd(x, NFFT=N, Fs=Fs, scale_by_freq=False)

# Plot periodogram
plt.subplot(211)
plt.plot(2 * np.pi * F, Sk)

# Theoretical PSD
Sx_th = power_x * np.ones(len(F))

# Mean of Sk (coincides with actual_power)
print(f'Mean of Sk: {np.mean(Sk)}')

# Periodogram standard deviation
print(f'Periodogram standard deviation: {np.std(Sk)}')

# Plot theoretical PSD
plt.plot(2 * np.pi * F, Sx_th, 'r:', linewidth=3)
plt.xlabel('Frequency (radians per second)')
plt.ylim(0, 100)  # Set y-axis limits
plt.ylabel('Power/Frequency (dB/Hz)')
plt.show()
