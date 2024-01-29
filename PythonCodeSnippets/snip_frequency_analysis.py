import matplotlib.pyplot as plt
import numpy as np


def main():
    # N is the number of available samples
    N = 256
    # FFT length
    n = np.arange(N)

    # Cosine function
    x2 = 100 * np.cos((2 * np.pi * 37.5 / N) * n + np.pi / 4) + np.cos(
        (2 * np.pi * 32 / N) * n + np.pi / 3
    )

    # DFT spacing in radians
    dw = (2 * np.pi) / N
    # Abscissa for plots matched to fftshift
    w = np.arange(-np.pi, np.pi, dw)
    # Perform windowing
    x = x2 * np.hamming(N)
    # Normalization to have stronger at 0 dB
    factor = np.max(np.abs(np.fft.fft(x)))
    # Shifted FFT function
    fft_shift = np.fft.fftshift(20 * np.log10(np.abs(np.fft.fft(x) / factor)))

    plt.plot(w, fft_shift)
    plt.xlabel("Frequency (radians/sample)")
    plt.ylabel("Magnitude (dB)")
    plt.title("FFT of Windowed Signal")
    plt.grid(True)
    plt.show()


if __name__ == "__main__":
    main()
