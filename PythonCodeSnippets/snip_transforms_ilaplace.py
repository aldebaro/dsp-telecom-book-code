import sympy as sp

t = sp.Symbol('t', positive=True)
s = sp.symbols('s')

a = 1
b = -1
c = -1 + 2*sp.I

X = (s - a) / ((s - b) * (s - c) * (s - sp.conjugate(c)))

X_ilaplace = sp.inverse_laplace_transform(X, s, t)
X_ilaplace = sp.expand(X_ilaplace.rewrite(sp.exp))
print(X_ilaplace)
