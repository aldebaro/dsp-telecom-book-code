import numpy as np
from scipy.io.wavfile import write as wr

Fs = 44100
Ts = 1 / Fs
Timpulses = 0.25
L = np.floor(Timpulses / Ts)
N = 4
impulseTrain = np.zeros(int(N * L))
b = 16
amplitude = 2 ** (b - 1) - 1
N = 0
while N * L < len(impulseTrain):
    impulseTrain[N * int(L)] = amplitude
    N = N + 1
wr("Sinal.wav", Fs, impulseTrain)
