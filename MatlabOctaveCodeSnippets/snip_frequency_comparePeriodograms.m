N=1024; n=(0:N-1)'; %number N of samples and column vector n
A=10; x=A*cos((2*pi/64)*n); %generate cosine with period 64
BW = 2*pi; %assumed bandwidth is 2*pi for discrete-time signals
S = abs(fft(x)).^2/(BW*N); %Periodogram (|FFT{x}|^2)/(BW * N)
Nfft = N; %avoid zero-padding in periodogram below:
[H,w]=periodogram(x,[],Nfft); %Using Matlab/Octave
Power = sum(H)*BW/N %Power from periodogram function
Power2 = sum(H)*w(end)/length(H) %Useful approximation
plot(w,H,'-o',w,S(1:N/2+1),'-x') %Compare the periodograms