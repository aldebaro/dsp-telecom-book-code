import numpy as np
from scipy.linalg import toeplitz

Nx = 10  # number of samples of input training sequence
x = np.random.randn(Nx, 1)  # arbitrary input signal, as a column vector

# arbitrary channel, also as a column vector
h = np.array([1, 0.4, 0.3, -0.2, 0.1]).reshape(-1, 1)

# prepare for convolution as matrix
first_col = np.r_[x.flatten(), np.zeros(len(h) - 1)]
first_row = np.r_[x[0], np.zeros(len(h) - 1)]
X = toeplitz(first_col, first_row)

y = np.dot(X, h)  # pass input signal through the channel
y = y + 0.3 * np.random.randn(*y.shape)  # add some random noise

# LS estimate via M-P pseudoinverse using pinv
h_est = np.dot(np.linalg.pinv(X), y)

# alternative LS estimate via M-P pseudoinverse
h_est2 = np.dot(np.dot(np.linalg.inv(np.dot(X.T, X)), X.T), y)

# mean squared error with pinv
MSE = np.mean(np.abs(h - h_est) ** 2)

# mean squared error via property
MSE2 = np.mean(np.abs(h - h_est2) ** 2)

# normalized MSE in dB
NMSE = 10 * np.log10(MSE / np.mean(np.abs(h) ** 2))

print("MSE = ", MSE)
print("MSE2 = ", MSE2)
print("NMSE = ", NMSE)
