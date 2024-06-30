N=1024; n=(0:N-1)'; %number N of samples and column vector n
A=10; x=A*cos((2*pi/64)*n); %generate cosine with period 64
Fs=500; BW = Fs; %Fs = BW = 500 Hz
[S_uni,f_uni] = periodogram(x,[],N,Fs); %Unilateral periodogram
[S_bil,f_bil] = periodogram(x,[],N,Fs,'twosided'); %Bilateral period.
Power = (BW/N)*sum(S_uni) %Power for unilateral periodograma
Power2 = (BW/N)*sum(S_bil) %Power for bilateral periodograma
length(f_uni),f_uni(end),length(f_bil),f_bil(end) %values for N even