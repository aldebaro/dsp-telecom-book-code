import numpy as np

# Specify: N-period, N1/N-duty cicle, N0-delay, k-frequency
N = 50
N1 = 15
N0 = 4
k = np.arange(0, N - 1)

xn = np.concatenate([np.ones(N1), np.zeros(N - N1)])  # x[n]
Xk = np.fft.fft(xn) / N  # calculate the FTFS of x[n]
phase = -2 * np.pi / N * N0 * k  # define linear phase
Yk = Xk * np.exp(1j * phase)  # impose the linear phase
yn = np.fft.ifft(Yk) * N  # recover signal in time domain
