N=12; %period in samples
n=transpose(0:N-1); %column vector representing abscissa
A=10; x=A*cos(pi/6*n + pi/3); %cosine with amplitude 10 V
X=(1/N)*fft(x);%calculate DFT and normalize to obtain DTFS

k=-N/2:N/2-1; %range with negative k (assume N is even)
X(abs(X)<1e-12)=0;%discard small values (numerical errors)
X=fftshift(X); %rearrange to represent negative freqs.
subplot(211);stem(k,abs(X));subplot(212);stem(k,angle(X));

