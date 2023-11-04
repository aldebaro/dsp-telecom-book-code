import numpy as np
from numpy.linalg import inv

# Non-orthogonal
i = np.transpose([[1, 1]])
j = np.transpose([[0, 1]])  

x = 3 * i + 2 * j  # Create an arbitrary vector x to be analyzed
A = np.concatenate((i, j), axis=1)# Organize basis vectors as a matrix

temp = np.dot(inv(A), x)
# Coefficients
alpha = temp[0]
beta = temp[1]
