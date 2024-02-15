import numpy as np
import matplotlib.pyplot as plt
from scipy.io import wavfile
from scipy.signal import spectrogram
from scipy.signal.windows import get_window

# Read WAV file
Fs, s = wavfile.read("../Applications/SignalFiles/WeWereAway.wav")
# Ensure signal is in float format for processing
s = s / np.power(2, 15)  # Assuming the WAV file has 16-bit depth; adjust if different

Nfft = 1024  # Number of FFT points
M = 64  # Window length

# Generate spectrogram
f, t, Sxx = spectrogram(
    s, Fs, window=get_window("hann", M), nfft=Nfft, noverlap=round(3 / 4 * M)
)
plt.figure(figsize=(10, 4))
plt.pcolormesh(t, f, 10 * np.log10(Sxx))
plt.ylabel("Frequency [Hz]")
plt.xlabel("Time [sec]")
plt.colorbar(label="Intensity [dB]")
plt.title("Spectrogram with M=64")
plt.pause(1)  # Pause to display the first figure

M = 256  # Update window length
# Generate spectrogram with the updated window length
f, t, Sxx = spectrogram(
    s, Fs, window=get_window("hann", M), nfft=Nfft, noverlap=round(3 / 4 * M)
)
plt.figure(figsize=(10, 4))
plt.pcolormesh(t, f, 10 * np.log10(Sxx))
plt.ylabel("Frequency [Hz]")
plt.xlabel("Time [sec]")
plt.colorbar(label="Intensity [dB]")
plt.title("Spectrogram with M=256")
plt.show()
