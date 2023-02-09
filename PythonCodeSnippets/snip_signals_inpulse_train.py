import numpy as np
from scipy.io.wavfile import write as wr

Fs = 44100
Ts = 1 / Fs
Timpulses = 0.25
L = np.floor(Timpulses / Ts)
N = 4
impulseTrain = np.zeros(int(N * L))
b = 16
amplitude = (2**(b - 1))-1
flag = 0
for i in range(len(impulseTrain)):
    if i == (int(L*flag)):
        flag = 1+flag
        impulseTrain[i] = amplitude
wr("Sinal.wav", Fs, impulseTrain.astype(np.int16))
