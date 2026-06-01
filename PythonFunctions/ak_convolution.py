import numpy as np


def ak_convolution(x: np.ndarray, h: np.ndarray) -> np.ndarray:
    """Convolution between sequences x and h using LIT properties."""
    Nx = len(x)              # number of samples in x
    Nh = len(h)              # number of samples in h
    N = Nx + Nh - 1          # number of samples in output y
    y = np.zeros(N)          # pre-allocate space for y[n]
    for k in range(Nx):
        # create indices n = k, k+1, ..., k+Nh-1 to mimic h[n-k]
        n_range_with_delay_k = np.arange(k, k + Nh)
        # add contribution of x[k] * h[n-k] to y[n]
        y[n_range_with_delay_k] += x[k] * h  # y[n] += x[k] h[n-k]
    return y


if __name__ == "__main__":  # Example usage
    x = np.array([2, -3, 4])
    h = np.array([-2, 1, 2])
    y = ak_convolution(x, h)
    print("x =", x), print("h =", h), print("y =", y)
