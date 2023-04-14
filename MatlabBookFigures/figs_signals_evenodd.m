clf
close all

x=[0 0 0 1 1 1 1 1]; n=-3:4; ak_getEvenOddParts(x,n);
writeEPS('evenodd_step')

n=1:100; x=n.^2; ak_getEvenOddParts(x,n);
writeEPS('evenodd_parabola')

M=40;x=[(0:M) (M-1:-1:0)]; n=20+(0:2*M); ak_getEvenOddParts(x,n);
writeEPS('evenodd_triangle')