import matplotlib.pyplot as plt
import numpy as np
import pylab as pl

####Define range
N = 300
delta_x = np.zeros(300)
delta_x1 = np.zeros(300)
x = np.linspace(-8, 8, N)

####Get the distance between the value and the next allowed value in single precsion
for i in range(N):
    delta_x[i] = np.abs(np.spacing(np.float32(x[i])))

####Get the distance between the value and the next allowed value in double precsion
for j in range(N):
    delta_x1[j] = np.abs(np.spacing(np.float64(x[j])))

plt.semilogy(x, delta_x, color="blue", label="float")
plt.semilogy(x, delta_x1, color="red", label="double")
plt.legend(loc="lower left")
pl.show()
