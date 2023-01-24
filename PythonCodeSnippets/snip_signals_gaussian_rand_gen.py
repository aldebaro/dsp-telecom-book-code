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
