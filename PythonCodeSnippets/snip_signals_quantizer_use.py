import matplotlib.pyplot as plt
import numpy as np


#### ak_quantizer assumes the quantizer allocates 2^(b-1)
# levels to negative output values, one levels to '0' and
# 2^(b-1) - 1 to positive values.
def ak_quantizer(x, delta, b):
    x_q = []
    x_i = []
    for i in range(len(x)):
        auxi = x[i] / delta  # Quantizer levels
        auxi = round(auxi)  # get the nearest integer
        if auxi > (2 ** (b - 1)) - 1:
            auxi = (2 ** (b - 1)) - 1  # Obligate a maximun value
        elif auxi < -(2 ** (b - 1)):
            auxi = -(2 ** (b - 1))  # Obligate a minimun value
        auxq = auxi * delta  # get the docoded output already quantized
        x_q.append(auxq)
        x_i.append(auxi)
    return x_i, x_q


delta = 0.5  # quantization step
b = 3  # Number of bits
x = np.arange(-5, 4, 1 * 10**-2)  # Define input dynamic range
x_i, x_q = ak_quantizer(x, delta, b)  # Do the quantization

plt.plot(x, x_q, color="red")
plt.legend(loc="lower left")
plt.show()
