import matplotlib.pyplot as plt
import numpy as np


def plot_semilogy(x: np.linspace, delta_x: np.zeros,
                  delta_x1: np.zeros) -> None:
    plt.semilogy(x, delta_x, color="blue", label="float")
    plt.semilogy(x, delta_x1, color="red", label="double")
    plt.legend(loc="lower left")
    plt.show()


def main():
    # Define range
    N = 300
    delta_x = np.zeros(300)
    delta_x1 = np.zeros(300)
    x = np.linspace(-8, 8, N)

    # Get the distance between the value and the next allowed
    # value in single precsion
    for i in range(N):
        delta_x[i] = np.abs(np.spacing(np.float32(x[i])))

    # Get the distance between the value and the next allowed
    # value in double precsion
    for j in range(N):
        delta_x1[j] = np.abs(np.spacing(np.float64(x[j])))

    plot_semilogy(x, delta_x, delta_x1)


if __name__ == "__main__":
    main()
