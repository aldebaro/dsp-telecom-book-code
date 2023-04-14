import matplotlib.pyplot as plt
import numpy as np
import pylab as pl
import scipy.stats as sp
from lasse.statistics.histograms import ak_normalize_histogram


B = 100  # setting the nunber of bins
newMean = 4
newVariance = 0.09
n = 10000
x = (
    np.sqrt(newVariance) * np.random.randn(1, n)
) + newMean  # Appling the new variance and new mean in random generating
n2, x2 = ak_normalize_histogram(x, B)
a = np.arange(2.5, 5.5, 0.1)
b = sp.norm.pdf(a, 4, np.sqrt(newVariance))  # Generating a gaussian (4, 0.09)

plt.plot(x2, n2, color="red", label="Normalized Histogram")
plt.plot(a, b, color="green", label="Gaussian")
plt.legend(loc="lower left")
pl.show()
