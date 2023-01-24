import numpy as np

a = np.float64(0)
for i in range(20):
    a += np.float64(0.1)
print(a == 2)
print(np.spacing(np.float64(1)))
print(np.abs(a) - 2 < np.spacing(np.float64(1)))
