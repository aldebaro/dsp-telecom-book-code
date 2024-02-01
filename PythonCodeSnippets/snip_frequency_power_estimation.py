import numpy as np


def main():
    N = 1024  # number of samples
    n = np.arange(N)  # column vector
    dw = 2 * np.pi / N  # FFT bin width

    A = 10  # cosine amplitude
    x = A * np.cos((2 * np.pi / 64) * n)  # cosine with period 64

    Sms = np.abs(np.fft.fft(x) / N) ** 2  # MS spectrum |DTFS{X}|^2
    S = np.abs(np.fft.fft(x)) ** 2 / N  # Periodogram (|FFT{x}|^2)/2

    # 1) Obtain Sms from periodogram
    Sms2 = S / N  # Example of obtaining from periodogram

    # 2) Alternative for computing power (power in Watts = A^2/2)
    Power = np.sum(Sms)  # a) from MS spectrum
    Power2 = 1 / (2 * np.pi) * (sum(S) * dw)  # b) assuming discrete-time PSD

    Fs = 1  # c) assuming continuous -time PSD (Fs is 1 Hz)
    df = Fs / N  # In this case c), bin width is df = 1/N Hz

    Power3 = df * sum(S)  # Power = power2 = power3

    print("Compare Sms from spectrum")
    print(Sms)
    print("With obtaining from periodogram")
    print(Sms2)

    print("Power: ", Power)
    print("Power2: ", Power2)
    print("Power3: ", Power3)


if __name__ == "__main__":
    main()
