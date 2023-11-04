import matplotlib.pyplot as plt
import numpy as np
import pylab as pl
from lasse.dsp.scalar_quantization import ak_quantizer


delta = 0.5  # quantization step
b = 3  # Number od bits
x = np.arange(-5, 4, 1 * 10 ** -2)  # Define input dynamic range
x_i, x_q = ak_quantizer(x, delta, b)  # Do the quantization

plt.plot(x, x_q, color="red")
plt.legend(loc="lower left")
plt.show()
