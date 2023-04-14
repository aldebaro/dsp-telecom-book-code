import numpy as np

a = np.float64(
    0
)  # a is defined as a float with a precision of 64 bits after the decimal point
for i in range(20):
    a += np.float64(0.1)  # 20 times  0.1  should be equal to 2
print(a)  # Final value of a
print(bool(a == 2))  # checking if a is 2 returns False due to numerical error
