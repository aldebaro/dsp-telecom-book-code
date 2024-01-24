import numpy as np
import sounddevice as sd

fs = 22050  # Sampling frequency

y = sd.rec(
    int(5 * fs), samplerate=fs, channels=1, dtype=np.int16
)  # retrieve 5s samples as int16
y = y[:, 0]
sd.wait()  # Wait until recording is finished

x = np.double(y)  # convert from int16 to double
sd.play(x, fs)  # play at the sampling frequency
sd.wait()
sd.play(x, np.round(fs / 2))  # play at half of the sampling freq.
sd.wait()
sd.play(x, 2 * fs)  # play at twice the sampling frequency
sd.wait()

w = x[[j for j in range(len(x)) if j % 2 == 0]]  # maintain half of the samples
sd.play(w, fs)  # play at the original sampling frequency
sd.wait()

z = np.zeros(2 * len(x))  # vector with twice the size of x
z[
    [j for j in range(len(z)) if j % 2 == 0]
] = x  # copy x into odd elements of z (even are 0)
sd.play(z, fs)  # play at the original sampling frequency
sd.wait()
