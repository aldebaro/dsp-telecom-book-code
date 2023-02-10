# Given maximum and minimum values
X_min = -1
X_max = 3

b = 2  # Number of quantizer's bits
M = 2 ** b  # Number of output levels

# Calculating the quantization step
delta = abs((X_max - X_min) / (M - 1))
print(delta)

# Get the output values
quantizer_levels = []
for i in range(M):
    quantizer_levels.append(X_min + i * delta)

# Find out if 0 is present in the output values
is_zero_represented = 0 in quantizer_levels

# If not present, force the output to contain 0
if not is_zero_represented:

    # Get the number of negatives output values
    num_negatives = 0
    for i in quantizer_levels:
        if i < 0:
            num_negatives += 1

    # Reassign the minimum value so that 0 will be represented
    X_min = -1 * num_negatives * delta
    print(X_min, num_negatives)

    # Once again find the output values
    new_quantizer_levels = []
    for i in range(M):
        new_quantizer_levels.append(X_min + i * delta)

    print(new_quantizer_levels)
