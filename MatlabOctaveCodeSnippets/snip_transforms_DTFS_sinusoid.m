N=32; %number of DFT-points
n=0:N-1; %abscissa to generate signal below
x=2+3*cos(2*pi*6/32*n)+8*sin(2*pi*12/32*n)-...
    + 4*cos(2*pi*7/32*n)+ 6*sin(2*pi*7/32*n);
X=fft(x)/N; %calculate DTFS spectrum via DFT
X(abs(X)<1e-12)=0; %mask numerical errors