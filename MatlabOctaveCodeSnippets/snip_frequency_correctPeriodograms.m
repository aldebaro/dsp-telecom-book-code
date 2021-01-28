N=1024; n=(0:N-1)'; %number N of samples and column vector n
A=10; x=A*cos((2*pi/64)*n); %generate cosine with period 64
Fs=500; BW = Fs; %Fs = BW = 500 Hz
[H,f] = periodogram(x,[],N,Fs); %Unilateral periodogram
[H2,f2] = periodogram(x,[],N,Fs,'twosided'); %Bilateral periodogram
Power = (BW/N)*sum(H) %Power for unilateral periodograma
Power2 = (BW/N)*sum(H2) %Power for bilateral periodograma
f(end), f2(end), length(f), length(f2) %values for N even