b=[0.6 0.1 2.3 4.5];
a=[1 -1.2 0.4 5.2 1.1];
[r,p,k]=residuez(b,a); %fraction expansion in Z domain
%note that using [b,a]=residuez(r,p,k) reconstructs b,a
%hence, create two SOS with pairs of fractions:
[b1,a1]=residuez([r(1) r(2)],[p(1) p(2)],0)
[b2,a2]=residuez([r(3) r(4)],[p(3) p(4)],0)

