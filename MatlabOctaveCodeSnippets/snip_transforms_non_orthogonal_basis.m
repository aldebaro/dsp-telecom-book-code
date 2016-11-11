i=transpose([1,1]), j=transpose([0,1]) %non-orthogonal
x=3*i+2*j %create an arbitrary vector x to be analyzed
A=[i j]; %organize basis vectors as a matrix
temp=inv(A)*x; alpha=temp(1), beta=temp(2) %coefficients

