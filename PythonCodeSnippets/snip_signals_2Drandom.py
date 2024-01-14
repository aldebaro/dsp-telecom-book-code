import numpy as np

N = 100000
mu = np.array([2, 3])
C = np.array([[1.0, 0.5], [0.5, 10.0]], dtype=float)
r = np.random.multivariate_normal(mu, C, N)
Cest = np.cov(r, rowvar=False)
numbiny = 30
numbiny = 30
mu_est = np.mean(r)
R = C + np.transpose(mu) * mu
Rest = Cest + np.transpose(mu_est) * mu_est
print("R=", R)
print("Rest=", Rest)
