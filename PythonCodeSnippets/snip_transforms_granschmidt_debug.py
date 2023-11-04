import numpy as np

tol = 1.1102e-015  # Calculated (default) tolerance

# First basis in y is [0  -0.7071  -0.7071  0], numBasis=1
k = 2
m = 1
projectionOverBasis = np.array([0, 2.0, 2.0, 0])  # 2nd input vector
errorVector = 1.0e-015 * np.array([0, 0.4441, 0.4441, 0])
magErrorVector = 6.2804e-016  # do NOT add error vector to basis set
# 2nd vector is already represented, go to next iteration
k = 3
m = 1
projectionOverBasis = np.array([0, 0.5, 0.5, 0])  # 3rd input vector
# errorVector below is orthogonal to [0 -0.7071 -0.7071 0]
errorVector = np.array([0, 0.5, -0.5, 1])
magErrorVector = 1.2247  # Add normalized error vector to basis set
# Second basis is [0 0.4082 -0.4082 0.8165], numBasis=2
k = 4
m = 1
projectionOverBasis = np.array([0, 1.0, 1.0, 0])  # 4th input vector
errorVector = np.array([1.0, 0.0, 0.0, 1])  # Using 1st basis
k = 4
m = 2
projectionOverBasis = np.array([0.0, 0.3333, -0.3333, 0.6667])
errorVector = np.array([1.0, -0.3333, 0.3333, 0.3333])  # Using 2 basis vectors
magErrorVector = 1.1547  # Add normalized error vector to basis set
# 3rd basis is [0.8660 -0.2887 0.2887 0.2887], numBasis=3
k = 5
m = 1
projectionOverBasis = np.array([0, 2.0, 2.0, 0])  # 5th input vector
errorVector = np.array([-2.0, 0.0, 0.0, 1.0])  # Using only 1st basis
k = 5
m = 2
projectionOverBasis = np.array([0, 0.3333, -0.3333, 0.6667])
errorVector = np.array([-2.0, -0.3333, 0.3333, 0.3333])  #  Using 2 basis vectors
k = 5
m = 3
projectionOverBasis = np.array([-1.25, 0.4167, -0.4167, -0.4167])
errorVector = np.array([-0.75, -0.75, 0.75, 0.75])  # Using 3 basis vectors
magErrorVector = 1.5000  # Add normalized error vector to basis set
# 4th basis is [-0.5 -0.5 0.5 0.5], numBasis=4
# Abort because (numBasis >= N)
