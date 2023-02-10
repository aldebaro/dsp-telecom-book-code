import matplotlib.pyplot as plt
import numpy as np
import scipy.signal as sp
from numpy import random as rd


def main():
    Fs = 8000  # sampling frequency
    Ts = 1 / Fs  # Sampling Period
    N = 1.5 * Fs  # Define a time of 1.5 second
    t = np.arange(0, N) * Ts

    if True:
        X = rd.rand(int(N)) - 0.5
    else:
        X = np.cos(2 * np.pi * 100 * t)

    dalayInSamples = 2000
    timeDelay = dalayInSamples * Ts
    zero = np.zeros(dalayInSamples)
    auxX = X[0 : len(X) - dalayInSamples]
    y = np.concatenate((zero, auxX))
    SNRdb = 10
    signalPower = np.mean(X**2)
    noisePower = signalPower / (10 ** (SNRdb / 10))
    noise = np.sqrt(noisePower) * rd.randn(np.size(y))
    y = y + noise
    plt.figure()
    plt.subplot(211)
    plt.plot(t, X)
    plt.plot(t, y)
    plt.show()

    c = sp.correlate(X, y, "full")
    lags = sp.correlation_lags(len(X), len(y), "full")

    index_max = max(range(len(c)), key=np.abs(c).__getitem__)
    L = lags[index_max]
    estimated_time_delay = L * Ts


if __name__ == "__main__":
    main()
