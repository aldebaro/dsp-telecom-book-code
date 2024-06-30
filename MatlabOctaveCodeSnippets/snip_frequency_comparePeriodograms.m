N=1024; n=(0:N-1)'; %number N of samples and column vector n
A=10; x=A*cos((2*pi/64)*n); %generate cosine with period 64
BW = 2*pi; %assume defaut Fs=2*pi (bandwidth) in periodogram
S = abs(fft(x)).^2/(BW*N); %Periodogram (|FFT{x}|^2)/(BW * N)
Nfft = N; %force the FFT size in the periodogram below:
[Suni,w]=periodogram(x,[],Nfft); %Unilateral periodogram
Power = sum(Suni)*BW/N %Power from unilateral periodogram 
Power2 = sum(S)*BW/N %Power from bilateral periodogram
Sunilateral2 = [S(1); 2*S(2:N/2); S(N/2+1)]; %from bi to unilateral
plot(w,Suni,'-o',w,Sunilateral2 ,'-x') %Compare periodograms