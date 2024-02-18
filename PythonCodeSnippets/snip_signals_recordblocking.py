# Python
import sounddevice as sd
import numpy as np
import matplotlib.pyplot as plt

fs = 11025  # Sample rate
seconds = 5  # Duration of recording

r = sd.rec(int(seconds * fs), samplerate=fs, channels=1, dtype="int16")
sd.wait()  # Wait until recording is finished
sd.play(r, fs)  # Play back the recording

# Plot the audio data
plt.plot(r)
plt.show()
