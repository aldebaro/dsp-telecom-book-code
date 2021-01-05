N=256; n=0:N-1; %N is the number of available samples and FFT length
x2=100*cos((2*pi*37.5/N)*n+pi/4) + cos((2*pi*32/N)*n+pi/3); %two cosines
dw=(2*pi)/N; %DFT spacing in radians
w=-pi:dw:pi-dw; %abscissa for plots matched to fftshift
x=x2.*hamming(N)'; %perform windowing
factor=max(abs(fft(x))); %normalization to have stronger cosine at 0 dB
plot(w,fftshift(20*log10(abs(fft(x)/factor))));

