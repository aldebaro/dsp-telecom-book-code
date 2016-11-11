%Specify: N-period, N1/N-duty cicle, N0-delay, k-frequency
N=50; N1=15; N0=4; k=0:N-1;
xn=[ones(1,N1) zeros(1,N-N1)]; %x[n]
Xk=fft(xn)/N; %calculate the DTFS of x[n]
phase = -2*pi/N*N0*k; %define linear phase 
Yk=Xk.*exp(j*phase); %impose the linear phase
yn=ifft(Yk)*N; %recover signal in time domain

