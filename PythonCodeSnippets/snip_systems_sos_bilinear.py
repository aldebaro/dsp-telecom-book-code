from sympy import symbols, simplify, pretty

# define s, z, natural frequency, damping ratio and sampling interval
s, z, wn, zeta, Ts = symbols("s z wn zeta Ts")

# H(s)
Hs = wn**2 / (s**2 + 2 * zeta * wn * s + wn**2)

# bilinear: s <- 2/Ts*(z-1)/(z+1)
Hz = Hs.subs(s, (2 / Ts) * ((z - 1) / (z + 1)))

# simplify the expression
Hz = simplify(Hz)

# show it using an alternative view
print(pretty(Hz))
