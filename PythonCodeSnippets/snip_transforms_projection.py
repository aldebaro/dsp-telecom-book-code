import numpy as np

x = np.array([2, 2])# Define a vector x

y = np.array([5, 1])# Define a vector y

magx = np.sqrt(np.sum(x * x))  # Magnitude of x
magy = np.sqrt(np.sum(y * y))  # Magnitude of y
innerprod = sum(x * y)  # <x,y>=||x|| ||y|| np.cos(theta)
theta = np.arccos(innerprod / (magx * magy))  # Angle between x and y
# obs: could use acosd to have angle in degrees
print("Angle is ", 180 * theta / np.pi, " degrees")
# Check if inverting direction is needed:
invertDirection = 1
if theta > np.pi / 2:
    invertDirection = -1


# Find the projection of x over y (called p_xy) and p_yx
mag_p_xy = magx * abs(np.cos(theta))  # Magnitude of p_xy
# Directions: obtained as y normalized by magy, x by magx
y_unitary = y / magy
# Normalize y by magy to get unitary vec.
p_xy = mag_p_xy * y_unitary * invertDirection  # p_xy
mag_p_yx = magy * abs(np.cos(theta))
# Magnitude of p_yx
x_unitary = x / magx
# Normalize x by magx to get unitary vec.
p_yx = mag_p_yx * x_unitary * invertDirection  # p_yx
# Test orthogonality of error vectors:
error_xy = x - p_xy
# We know: p_xy + error_xy = x
sum(error_xy * y)  # This inner product should be zero
error_yx = y - p_yx
# We know: p_yx + error_yx = y
sum(error_yx * x)  # This inner product should be zero
