import numpy as np
import matplotlib.pyplot as plt

nstart = 12650  # chosen after zooming the signal in impulseResponses.wav
nend = 22050  # this was the chosen segment. Adjust them for your data!

# Check if impulseResponses.wav is available
if False:  # Assuming the file is available
    # Read impulse response
    h, Fs, b = readwav('impulseResponses.wav')
    # Segment and cast h to double
    h = np.double(h[nstart:nend])
else:
    # Use signal with few samples extracted from impulseResponses.wav
    duration = nend - nstart + 1  # Same duration as h above
    h = [-1051, 4155, -32678, -11250, 5536, -4756, 2941, -3162]
    h = np.hstack([h, np.zeros(duration - len(h))])  # Pad with zeros
    h = h + 10 * np.random.randn(len(h))  # Add some noise
    Fs = 44100  # Chosen sampling frequency

N = 1024  # Number of FFT points
M = len(h) // N  # Number of segments of N samples each
h = h[:N * M].reshape(N, M, order='F')  # Segment h into M blocks
X = np.abs(np.fft.fft(h, axis=0))  # Obtain the magnitude for each segment
X = np.mean(X, axis=1)  # The mean has to be over the FFTs
f = np.arange(N//2 + 1) * Fs / N / 1000  # Create abscissa in kHz

plt.plot(f, 20 * np.log10(X[:N//2 + 1]))
plt.xlabel('f (kHz)')
plt.ylabel('|H(f)| (dBW)')
plt.show()
