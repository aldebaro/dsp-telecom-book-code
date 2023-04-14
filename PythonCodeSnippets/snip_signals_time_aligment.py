import matplotlib.pyplot as plt
import numpy as np
import scipy.signal as sp
from typing import Tuple


def delete_samples(L: sp.correlation_lags, x: np.ndarray,
                   y: np.ndarray) -> Tuple[np.ndarray]:
    # Remove L first items from two 1D signal arrays
    return (x[L:], y) if L > 0 else (x, y[-L:])


def set_same_length(x: np.ndarray, y: np.ndarray) -> np.ndarray:
    # Compute minimum length among two 1D signal arrays
    # and return both with same size
    min_length = min(len(x), len(y))
    return x[:min_length], y[:min_length]


def main():
    # Signals
    x = np.array([1, -2, 3, 4, 5, -1])
    y = np.array([3, 1, -2, -2, 1, -4, -3, -5, -10])

    # Compute Crosscorrelation and lags array
    c = sp.correlate(x, y)
    lags = sp.correlation_lags(len(x), len(y))

    # Find position of max lag
    index_max = max(range(len(c)), key=np.abs(c).__getitem__)
    L = lags[index_max]

    # Rearange signals sizes based on max lag
    x, y = delete_samples(L=L, x=x, y=y)
    x, y = set_same_length(x=x, y=y)

    # Plot results
    plt.plot(np.array(x - y))
    plt.title("Error between aligned x and y")
    plt.show()


if __name__ == "__main__":
    main()

