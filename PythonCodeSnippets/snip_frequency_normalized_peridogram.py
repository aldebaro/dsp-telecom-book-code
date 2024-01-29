import matplotlib.pyplot as plt
import numpy as np


def main():
    N = 1024
    A = 10
    n = np.arange(N)
    x = A * np.cos(2 * np.pi / 64 * n)  # Generate cosine
    Fs = 8000  # Sampling frequency
    rectWindow = np.ones(N)  # Array of ones of N size
    x = x.reshape(-1, 1)
    rectWindow = rectWindow.reshape(-1, 1)  # Adding one dimension in each element
    df = Fs / N  # FFT bin width
    P, w = plt.psd(
        x.flatten(), NFFT=N, Fs=Fs, window=rectWindow.flatten(), scale_by_freq=False
    )  # Periodogram
    Power = np.sum(P) * df  # Calculate again, to compare with Power

    print("Power:", Power)  # Plotting with linear scale

    plt.plot(w, P)
    plt.xlabel("f (Hz)")
    plt.ylabel("S(f)")
    plt.legend()
    plt.show()


if __name__ == "__main__":
    main()
