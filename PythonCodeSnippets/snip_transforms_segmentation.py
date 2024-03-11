import numpy as np
from numpy.random import rand
import matplotlib.pyplot as plt

S = 10000 # Some arbitrary number of samples

x = rand(S) # Create some very very long vector

N = 50 # Number of samples per frame (or block)

M = np.floor(S / N) # Number of blocks, floor may discard last block samples

M = np.floor(S / N).astype(int) # Number of blocks, floor may discard last block samples

powerPerBlock = np.zeros(M) # Pre-allocate space

for m in range(M):  # Following the book convention
    beginIndex = m * N  # Index of the m-th block start
   
    endIndex = beginIndex + N  # m-th block end index
   
    xm = x[beginIndex:endIndex]  # The samples of m-th block
    powerPerBlock[m] = np.mean(abs(xm) ** 2) # Estimate power of block xm
    
plt.subplot(211)
plt.plot(x)
plt.subplot(212)
plt.plot(powerPerBlock)
plt.show()
