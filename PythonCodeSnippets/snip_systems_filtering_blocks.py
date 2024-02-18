import numpy as np
from scipy.signal import butter, lfilter, lfilter_zi

# Input signal to be filtered, in Volts
x = np.concatenate([np.arange(1, 21), np.arange(20, 0, -1)])

# IIR filter
B, A = butter(8, 0.3)

# Block length
N = 5

# Number of blocks
num_blocks = len(x) // N

# Initialize the filter memory with zero samples
Zi = lfilter_zi(B, A)

# Pre-allocate space for the output
y = np.zeros_like(x)

# Process each block
for i in range(num_blocks):
    start_sample = i * N  # Begin of current block
    end_sample = start_sample + N  # End of current block
    xb = x[start_sample:end_sample]  # Extract current block

    # Filter and update memory
    yb, Zi = lfilter(B, A, xb, zi=Zi)

    # Update vector y
    y[start_sample:end_sample] = yb

# If you need to plot the original and filtered signal, you can use Matplotlib
# import matplotlib.pyplot as plt
# plt.plot(x, label='Original Signal')
# plt.plot(y, label='Filtered Signal')
# plt.legend()
# plt.show()
