from matplotlib import pyplot as plt
import numpy as np


def ak_convolution2(first_seq, second_seq,
                    start_idx_first_seq, start_idx_second_seq):
    N1 = len(first_seq)  # get the number of samples in the first sequence
    N2 = len(second_seq)  # get the number of samples in the second sequence
    N = N1 + N2 - 1
    y = np.zeros(N)  # pre-allocate space for y[n]

    for i in range(N1):
        for j in range(N2):  # calculate y[n] = sum_k x1[k] x2[n-k]
            y[i+j] = y[i+j] + first_seq[i]*second_seq[j]

    time_index = np.arange(start_idx_first_seq + start_idx_second_seq,
                           start_idx_first_seq + start_idx_second_seq + N)

    return y, time_index


x1 = np.arange(1, 4)  # define sequence x1
x2 = np.arange(5, 9)  # define sequence x2
x1_axis = np.arange(-3, 0)  # define abscissa for x1
x2_axis = np.arange(2, 6)  # define abscissa for x2

plt.tight_layout()
plt.subplots_adjust(hspace=0.4)
plt.subplot(311)
plt.ylim([0, 4])
plt.title('Discrete Convolution')
plt.stem(x1_axis, x1)
plt.subplot(312)
plt.stem(x2_axis, x2)

# calculate convolution
y, n = ak_convolution2(x1, x2, x1_axis[0], x2_axis[0])
plt.subplot(313)
plt.xlabel('$n$')
plt.stem(n, y, 'g')  # show result with proper time axis
plt.show()
