function Q = ak_qfuncApprox(x)

indicesNegativeNum = find(x<0);
x(indicesNegativeNum) = -x(indicesNegativeNum);
Q = (1./(((pi-1)/pi)*x+(1/pi)*sqrt(x.^2+2*pi))).* ...
    (1/sqrt(2*pi)).*exp(-x.^2/2);
Q(indicesNegativeNum) = 1-Q(indicesNegativeNum);
