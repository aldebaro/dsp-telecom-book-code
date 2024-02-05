import numpy as np
import scipy.io.wavfile as wav
from spectrum import aryule
import matplotlib.pyplot as plt

# read wav file
Fs, s = wav.read("./Applications/SignalFiles/WeWereAway.wav")
s = s / (2**15 - 1)  # normalize to -1 to 1
s = s - np.mean(s)  # extract any eventual DC level

Nfft = 1024  # number of FFT points
N = len(s)  # number of samples in signal
frame_duration = 160  # frame duration
step = 80  # number of samples the window is shifted
order = 10  # LPC order
numFormants = 4  # desired number of formants
# calculate the number of frames in signal
numFrames = int(np.floor((N - frame_duration) / step)) + 1
window = np.hamming(frame_duration)  # window for LPC analysis
formants = np.zeros((numFrames, numFormants))  # preallocate

for i in range(numFrames):  # go over all frames
    startSample = i * step  # first sample of frame
    endSample = startSample + frame_duration  # frame end
    x = s[startSample:endSample]  # extract frame samples
    x = x * window  # windowing
    a, _, _ = aryule(x, order)  # LPC analysis
    a = np.concatenate(([1], a))  # Matlab adds 1 to the start of the array
    poles = np.roots(a)  # Roots of filter 1/A(z)
    freqsInRads = np.arctan2(np.imag(poles), np.real(poles))  # angles
    freqsInHz = np.round(np.sort(freqsInRads * (Fs / (2 * np.pi))))  # in Hz
    frequencies = freqsInHz[freqsInHz > 5]  # keeps only > 5 Hz
    formants[i, :] = frequencies[0:numFormants]  # formants

window = np.blackman(64)  # window for the spectrogram
plt.specgram(
    s,
    NFFT=64,
    Fs=Fs,
    window=window,
    pad_to=Nfft,
    noverlap=int(np.round(3 / 4 * len(window))),
    cmap="plasma",
)
plt.ylabel("Frequency (Hz)")
plt.xlabel("Time (s)")

t = np.linspace(0, N / Fs, numFrames)  # abscissa

for i in range(numFormants):  # plot the formants
    for j in range(numFrames):
        plt.text(t[j], formants[j, i], str(i + 1), color="blue")

plt.show()
