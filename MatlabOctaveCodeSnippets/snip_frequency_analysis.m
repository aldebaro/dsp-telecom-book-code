N=256; n=0:N-1; %N is the number of samples available of x1 and x2
x2=100*cos((2*pi*37.5/N)*n+pi/4) + cos((2*pi*32/N)*n+pi/3); %x2[n]
dw=(2*pi)/N; %DFT spacing in rads
w=-pi:dw:pi-dw; %abscissa for plots
x=x2.*hamming(N)'; %perform windowing
factor=max(abs(fft(x))); %normalization factor
plot(w,fftshift(20*log10(abs(fft(x)/factor))));

