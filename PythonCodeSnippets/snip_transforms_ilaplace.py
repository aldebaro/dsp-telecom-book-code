import sympy as sp

s = sp.symbols('s')
t = sp.Symbol('t', positive=True)
a = 1
b = -2
c = -1 + 2*sp.I

X = (s - a) / ((s - b) * (s - c) * (s - sp.conjugate(c)))

ilaplace_X = sp.inverse_laplace_transform(X, s, t)
print(ilaplace_X)
