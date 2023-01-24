import numpy as np

fmax = np.finfo(np.float64).max
fmin = np.finfo(np.float64).min
nfmax = -fmax
nfmin = -fmin
print(
    f"Ranges  for  double  before  and  after  0:\n{nfmax} to {nfmin} and {fmin} to {fmax}"
)

fmax = np.finfo(np.float32).max
fmin = np.finfo(np.float32).min
nfmax = -fmax
nfmin = -fmin
print(
    f"Ranges  for  float  before  and  after  0:\n{nfmax} to {nfmin} and {fmin} to {fmax}"
)

print(np.finfo(0.135).eps)
