import numpy as np


def ak_causal_convolution(x: np.ndarray, h: np.ndarray) -> np.ndarray:
    """ Convolution assuming causal finite-length sequences."""
    Nx = len(x)              # number of samples in x
    Nh = len(h)              # number of samples in h
    N = Nx + Nh - 1          # number of samples in output y
    y = list()        # initialize an empty list to store the convolution
    for n in range(N):
        # find the valid range of k for each value of n
        kmin = max(0, n - (Nx - 1))
        kmax = min(Nh - 1, n)
        acc = 0  # accumulator variable for calculating y[n]
        for k in range(kmin, kmax + 1):
            acc += h[k] * x[n - k]
        y.append(acc)  # append the calculated value of y[n] to the list y
    return np.array(y)


if __name__ == "__main__":  # Example usage
    x = np.array([2, -3, 4, 5, 1])
    h = np.array([-2, 1])
    y = ak_causal_convolution(x, h)
    print("x =", x), print("h =", h), print("y =", y)
