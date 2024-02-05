import matplotlib.pyplot as plt
import numpy as np
from scipy.signal.windows import flattop
from scipy.signal import welch


def main():
    N = 1024
    n = np.arange(N)
    x = 10 * np.cos(2 * 3 / 64 * (n))

    Xk = np.abs(np.fft.fft(x, N) / N) ** 2
    Fs = 1
    window = flattop(N)

    frequencies, H = welch(x, fs=Fs, window=window, nperseg=N,
                           return_onesided=False)
    H = H * sum(window**2) / sum(window) ** 2  # scale for MS

    plt.plot(Xk, "x-", label="|DTFS|^2")
    plt.plot(H, "or-", label="Welch's estimate")
    plt.legend()
    plt.show()


if __name__ == "__main__":
    main()
