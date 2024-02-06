from scipy.signal import freqz, firls

f = [0, 0.25, 0.3, 0.55, 0.6, 0.85, 0.9, 1]  # frequencies
A = [1, 1, 0, 0, 1, 1, 0, 0]  # amplitudes
M = 20  # filter order
W = [1000, 1, 1, 1]  # weights, first passband is prioritized

B = firls(M, f, A, weights=W)  # Design FIR filter using firls
freqz(B)
