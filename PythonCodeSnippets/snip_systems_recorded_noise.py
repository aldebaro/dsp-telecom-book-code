import numpy as np
import matplotlib.pyplot as plt
from scipy.io import wavfile

def readwav(filename):
    """Função de leitura de arquivo WAV simplificada."""
    return wavfile.read(filename)

x, Fs = readwav('filteredNoise.wav')

N = 1024

M = len(x) // N

x = x[:N*M].reshape(-1, 1)

xsegments = x.reshape(N, M)

X = np.abs(np.fft.fft(xsegments, axis=0))

X = np.mean(X.T, axis=0)

f = Fs / N * np.arange(N/2 + 1) / 1000

plt.plot(f, 20 * np.log10(X[:N//2 + 1]))
plt.xlabel('f (kHz)')
plt.ylabel('|H(f)| (dBW)')
plt.show()
