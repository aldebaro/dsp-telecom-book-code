N=10; N1=5; k=0:N-1; %define durations and k
Xk=(1/N)*(sin(k*N1*pi/N)./sin(k*pi/N)) .* ...
    exp(-j*k*pi/N*(N1-1)); %obtain DTFS directly
Xk(1)=N1/N; %eliminate the NaN (not a number) in Xk(1)
%second alternative, via DFT. Generate x[n]:
xn=[ones(1,N1) zeros(1,N-N1)] %single period of x[n]
Xk2=fft(xn)/N %DTFS via DFT, Xk2 is equal to Xk

