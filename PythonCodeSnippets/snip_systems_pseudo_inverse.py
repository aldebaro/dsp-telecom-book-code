import numpy as np
from numpy.linalg import LinAlgError, matrix_rank, inv
from scipy.linalg import pinv

# Choose the case below
test = 3

if test == 1:  # m > n (overdetermined/tall) and linearly indepen. columns
    X = np.matrix(
        [[1, 2, 3], [-4 + 1j, -5 + 1j, -6 + 1j], [1, 0, 0], [0, 1, 0]]
    )
elif test == 2:  # n > m (underdetermined/fat) and linearly independent rows
    X = np.matrix([[1, 2, 3], [-4 + 1j, -5 + 1j, -6 + 1j]])
elif test == 3:  # neither rows nor columns of X are linearly independent
    X = np.matrix(
        [[1, 2, 3, 3], [2, 4, 6, 6], [-4 + 1j, -5 + 1j, -6 + 1j, -12 + 3 * 1j]]
    )

# Pseudoinverse via SVD decomposition
Xp_svd = pinv(X)
# Pseudoinverse when columns are linearly independent
Xp_over = inv(X.H @ X) @ X.H

# Pseudoinverse when rows are linearly independent
try:
    Xp_under = X.H @ inv(X @ X.H)
except LinAlgError:
    Xp_under = np.full(X.H.shape, np.nan)

print(matrix_rank(X.H @ X))  # X.H @ X is square but may not be full rank
print(matrix_rank(X @ X.H))  # X @ X.H is square but may not be full rank
Xhermitian = X.H @ X @ pinv(X)  # equal to X.H (this property is always valid)
Xhermitian2 = pinv(X) @ X @ X.H  # equal to X.H (the property itself is valid)
maxError_over = np.max(np.abs(Xp_svd - Xp_over))  # for underdetermined
maxError_under = np.max(np.abs(Xp_svd - Xp_under))  # error for overdetermined
