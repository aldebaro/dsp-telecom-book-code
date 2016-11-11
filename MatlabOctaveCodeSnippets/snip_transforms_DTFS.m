N=12; %period in samples
n=transpose(0:N-1); %column vector representing abscissa
Vp=10; x=Vp*cos(pi/6*n + pi/3); %cosine with amplitude 10 V
X=(1/N)*fft(x);%calculate DFT and normalize to obtain DTFS
A=ak_fftmtx(N,2); %DFT matrix with the DTFS normalization
X2=A*x; %calculate the DTFS via the normalized DFT matrix

