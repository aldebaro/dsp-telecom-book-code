import matplotlib.pyplot as plt
from scipy.signal.windows import hann, kaiser, flattop, hamming
from scipy.signal import get_window


def main():
    N = 256

    # Rectangular window
    W_rect = get_window("boxcar", N)

    # Hamming window
    W_hamming = hamming(N)

    # Hann window
    W_hann = hann(N)

    # Kaiser window with beta=7.85
    W_kaiser = kaiser(N, beta=7.85)

    # Flat top window
    W_flattop = flattop(N)

    # Plot the windows
    plt.plot(W_rect, label="Rectangular")
    plt.plot(W_hamming, label="Hamming")
    plt.plot(W_hann, label="Hann")
    plt.plot(W_kaiser, label="Kaiser")
    plt.plot(W_flattop, label="Flat Top")

    plt.legend()
    plt.title("Window Functions")
    plt.show()


if __name__ == "__main__":
    main()
