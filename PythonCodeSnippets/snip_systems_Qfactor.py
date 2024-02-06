import numpy as np

# Define the complex poles
p1 = -300 + 1j * 4000
p2 = -300 - 1j * 4000

# Convert the poles to a polynomial A(s)
A = np.poly([p1, p2])

# Calculate the natural frequency and damping factor
omega_n = np.sqrt(A[2])
alpha = A[1] / 2

# Calculate the Q-factor
Q = omega_n / (2 * alpha)

# Print the Q-factor
print(Q)