#  import matplotlib.pyplot as plt
import time as tm

import numpy as np
import scipy.fft as sp

n = 2 ** 20  # getting the FFT length

xs = np.float32(np.random.rand(n))  # Generate random signal with single precsion
xd = np.random.rand(n)  # Generate random signal with double precsion

tic = tm.time()  # starting the time
Xs = sp.fft(xs)  # Doing a FFT with single precisio
toc = tm.time()  # stoping the time
####Seeing the time
print(f"single precision: ")
print("Elapsed time is " + str(toc - tic) + " seconds.")

tic = tm.time()  # starting the time
Xd = sp.fft(xd)  # Doing a FFT with double precisio
toc = tm.time()  # stoping the time
####Seeing the time
print(f"double precision: ")
print("Elapsed time is " + str(toc - tic) + " seconds.")
