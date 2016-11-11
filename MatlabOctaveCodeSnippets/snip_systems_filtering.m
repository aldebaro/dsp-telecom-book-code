[B,A]=butter(8,0.3); %IIR filter
h=impz(B,A,50); %obtain h[n], truncated in 50 samples
grpdelay(B,A); %plots the group delay of the filter
x=[1:20,20:-1:1]; %input signal to be filtered, in Volts
X=fft(x)/length(x); %FFT of x, to be read in Volts
y=conv(x,h); %convolution y=x*h

