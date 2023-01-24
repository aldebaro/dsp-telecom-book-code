import numpy as np

x = np.array((1 + 1j, 2 + 0j, 3 + 0j), dtype=np.complex_)
N = len(x)
R = np.zeros(N, dtype=np.complex_)
y = sum(np.absolute(x) ** 2)
R[0] = y
for i in range(N - 1):
    temp = 0
    for n in range(N - 1 - i):
        temp = temp + (x[n + i + 1] * x[n].conjugate())
    R[i + 1] = temp
Q = np.conjugate(np.flip(R[1:]))
print(Q)
