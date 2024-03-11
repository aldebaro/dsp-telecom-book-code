import numpy as np

N = 256  # number of samples available for x1 and x2
n = np.arange(N).reshape(-1, 256)  # abscissa
k_weak = 32  # FFT bin where the weak cosine is located
k_strong1 = 38  # FFT bin for strong cosine in x1
weak_signal = 1 * np.cos((2 * np.pi * k_weak / N) * n + np.pi / 3)  # common parcel
x1 = 100 * np.cos((2 * np.pi * k_strong1 / N) * n + np.pi / 4) + weak_signal  # x1[n]
k_strong2 = 37.5  # location for strong cosine in x2
x2 = 100 * np.cos((2 * np.pi * k_strong2 / N) * n + np.pi / 4) + weak_signal  # x2[n]
