from scipy import signal
import matplotlib.pyplot as plt
import numpy as np

N = 4  # prototype order (bandpass order is 2N = 8)

# prototype with cutoff=1 rad/s
B, A = signal.butter(N, 1, 'low', analog=True)

# convert to cutoff=50 and BW=30 rad/s
Bnew, Anew = signal.lp2bp(B, A, 50, 30)

# plot mag (linear scale) and phase
w, h = signal.freqs(Bnew, Anew)

plt.figure()
plt.subplot(2, 1, 1)
plt.semilogx(w, 20 * np.log10(abs(h)))
plt.title('Butterworth filter frequency response')
plt.xlabel('Frequency [radians / second]')
plt.ylabel('Amplitude [dB]')
plt.margins(0, 0.1)
plt.grid(which='both', axis='both')
plt.axvline(100, color='green')  # cutoff frequency
plt.subplot(2, 1, 2)
angles = np.unwrap(np.angle(h))
plt.semilogx(w, angles)
plt.title('Phase')
plt.xlabel('Frequency [radians / second]')
plt.ylabel('Phase [radians]')
plt.grid(which='both', axis='both')
plt.axvline(100, color='green')  # cutoff frequency
plt.show()
