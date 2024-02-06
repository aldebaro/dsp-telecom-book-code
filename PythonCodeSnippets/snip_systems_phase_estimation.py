from scipy.io import wavfile
import numpy as np
import matplotlib.pyplot as plt

# Read the wav file
Fs, h = wavfile.read("impulseResponses.wav")

# when second \delta[n] occurs in impulses.wav
nstart = 11026

# segment ends before the third \delta[n] in impulses.wav
nend = 22050

# segment and cast h to double
h = h[nstart:nend].astype(float)

# it's convenient to make N an even number to use N/2
N = len(h) - 1

# calculate FFT
H = np.fft.fft(h, N)

# unwrap the phase for positive freqs.
p = np.unwrap(np.angle(H[: N // 2 + 1]))

# create abscissa in kHz. Fs/N is the bin width
f = Fs / N * np.arange(0, N / 2 + 1) / 1000

# plot
plt.plot(f, p)
plt.xlabel("f (kHz)")
plt.ylabel("angle{H(f)} (rad)")

# choose any 2 points
k1 = 1500
k2 = 4000

# Calculate derivative as the slope. Convert from kHz to rad/s first:
groupDelayInSeconds = -np.arctan2(p[k2] - p[k1], 2 * np.pi * 1000 * (f[k2] - f[k1]))
