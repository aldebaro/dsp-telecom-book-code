N=3; %filter order
fc=0.4*pi; %cutoff frequency (rad)
h=fir1(N,fc/pi); %design lowpass filter
n=0:1000-1; %abscissa
x=4*cos(pi/8*n) + 6*cos(0.7*pi*n+pi/5); %input signal
y=conv(x,h); %filter
xRecovered=deconv(y,h); %try to deconvolve

