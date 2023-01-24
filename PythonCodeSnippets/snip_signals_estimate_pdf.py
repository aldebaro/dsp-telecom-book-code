import matplotlib.pyplot as plt
import numpy as np
import pylab as pl
import scipy.stats as sp


####Function that get the values of a histogram and the central position of a bin
def ak_normalize_histogram(y, numBins=10):
    pdf_aproximation, abcissa = np.histogram(y[0], numBins)
    aux = []
    for i in range(len(abcissa) - 1):
        aux.append((abcissa[i] + abcissa[i + 1]) / 2)
    rg = np.max(aux) - np.min(aux)
    binwidth = rg / len(pdf_aproximation)
    pdf_aproximation = pdf_aproximation / (len(y[0]) * binwidth)
    return pdf_aproximation, aux


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
