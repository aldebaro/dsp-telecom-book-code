import numpy as np
import matplotlib.pyplot as plt
from scipy.io import wavfile
from scipy.signal import spectrogram
from scipy.signal.windows import hann

# Read WAV file
Fs, s = wavfile.read("../Applications/SignalFiles/WeWereAway.wav")
# Convert to float for processing if it's not already (assuming 16-bit depth)
s = s.astype(np.float32) / np.max(np.abs(s))

# Retrieve number of bits per sample, assuming 16-bit depth
numbits = 16  # This assumes 16-bit depth; adjust if your file is different

Nfft = 1024  # Number of FFT points

# Wideband spectrogram with M=64
M = 64  # Window length in samples for wideband
plt.figure(1)
f, t, Sxx = spectrogram(s, Fs, window=hann(M), nfft=Nfft, noverlap=round(3 / 4 * M))
plt.pcolormesh(t, f, 10 * np.log10(Sxx))
plt.ylabel("Frequency [Hz]")
plt.xlabel("Time [sec]")
plt.colorbar(label="Intensity [dB]")
plt.title("Wideband Spectrogram (M=64)")

# Narrowband spectrogram with M=256
M = 256  # Window length in samples for narrowband
plt.figure(2)
f, t, Sxx = spectrogram(s, Fs, window=hann(M), nfft=Nfft, noverlap=round(3 / 4 * M))
plt.pcolormesh(t, f, 10 * np.log10(Sxx))
plt.ylabel("Frequency [Hz]")
plt.xlabel("Time [sec]")
plt.colorbar(label="Intensity [dB]")
plt.title("Narrowband Spectrogram (M=256)")

plt.show()
