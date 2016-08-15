syms s %defines s as a symbolic variable
a=1; b=-2; c=-1+j*2; %choose poles and zeros
X=(s-a)/((s-b)*(s-c)*(s-conj(c))); %define X(s)
ilaplace(X) %Matlab's inverse unilateral Laplace transform

