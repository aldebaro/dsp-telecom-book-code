import numpy as np
from matplotlib import pyplot as plt
from scipy import signal

dataset_filename = '../Applications/SignalFiles/sunspot.dat'

sunspot = np.loadtxt(dataset_filename)

year = sunspot[:, 0]
wolfer = sunspot[:, 1]

# plot(year,wolfer)
plt.title('Sunspot Data')  # plot raw data
x = wolfer - np.mean(wolfer)  # remove mean
R = signal.correlate(x, x, mode="full")
lags = signal.correlation_lags(x.size, x.size, mode="full")
plt.plot(lags, R)
index = np.where(lags == 11)[0][0]  # %we know the 2nd peak is lag=11
plt.plot(lags[index], R[index], 'r.', 25)
plt.annotate(
    '2nd peak at lag=11',
    xy=(lags[index], R[index]),
    xytext=(100, 20*10e3),
    arrowprops=dict(arrowstyle="->", facecolor='black'),
    horizontalalignment='center', verticalalignment='bottom')
plt.show()
