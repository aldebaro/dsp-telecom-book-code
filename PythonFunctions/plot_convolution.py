''' 
Example code for plotting the convolution interpretation of the convolution sum.
'''

import numpy as np
import matplotlib.pyplot as plt


def plot_convolution_interpretation():
    x = np.array([2, -3, 4])
    h = np.array([-2, 1, 2])

    Nx = len(x)
    Nh = len(h)
    Ny = Nx + Nh - 1

    n_values = range(Ny)  # n from 0 to Ny-1

    # Wide k-axis for visualization
    k = np.arange(-4, 7)

    for n in n_values:
        h_k = np.zeros_like(k, dtype=float)
        x_n_minus_k = np.zeros_like(k, dtype=float)

        # h[k]
        for i, ki in enumerate(k):
            if 0 <= ki < Nh:
                h_k[i] = h[ki]

        # x[n-k]
        for i, ki in enumerate(k):
            index = n - ki
            if 0 <= index < Nx:
                x_n_minus_k[i] = x[index]

        product = h_k * x_n_minus_k
        y_n = np.sum(product)

        plt.figure(figsize=(8, 7))

        plt.subplot(3, 1, 1)
        plt.stem(k, h_k)
        plt.title(rf"$h[k]$, for $n={n}$")
        plt.ylabel(r"$h[k]$")
        plt.grid(True)

        plt.subplot(3, 1, 2)
        plt.stem(k, x_n_minus_k)
        plt.title(rf"$x[n-k]$, with $n={n}$")
        plt.ylabel(r"$x[n-k]$")
        plt.grid(True)

        plt.subplot(3, 1, 3)
        plt.stem(k, product)
        plt.title(rf"$h[k]x[n-k]$, sum = $y[{n}]={y_n}$")
        plt.xlabel(r"$k$")
        plt.ylabel("product")
        plt.grid(True)

        plt.tight_layout()
        plt.show()


if __name__ == "__main__":
    plot_convolution_interpretation()
