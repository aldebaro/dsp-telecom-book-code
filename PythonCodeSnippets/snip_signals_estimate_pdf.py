import matplotlib.pyplot as plt
import numpy as np
import pylab as pl
import scipy.stats as sp
from lasse.statistics.histograms import ak_normalize_histogram


B = 10  # setting the nunber of bins
x = np.random.randn(
    1, 100
)  # Generating random nunbers with the probability given by a Gaussian N(0,1)
n2, x2 = ak_normalize_histogram(x, B)
a = np.arange(-3, 3, 0.1)  # Getting samples around the mean
b = sp.norm.pdf(a, 0, 1)  # Generating a gaussian (0,1)
plt.plot(x2, n2, color="red", label="Normalized Histogram")
plt.plot(a, b, color="green", label="Gaussian")
plt.legend(loc="lower left")
pl.show()
