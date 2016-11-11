Gs=20*log10(0.01)
Gp=20*log10(0.95)
Wp=1/4
Ws=2/3
[n, Wc] = buttord(Wp, Ws, -Gp, -Gs)
[b, a]=butter(n,Wc)

