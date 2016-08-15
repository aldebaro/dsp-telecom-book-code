zeros=[0.3*exp(j*pi/2) 0.3*exp(-j*pi/2) ...
 0.8*exp(j*pi/4) 0.8*exp(-j*pi/4)];
h=poly(zeros);
n=0:1000-1; %abscissa
x=4*cos(pi/8*n) + 6*cos(0.7*pi*n+pi/5); %input signal
y=conv(x,h); %filter
xRecovered=deconv(y,h); %try to deconvolve
plot(x-xRecovered) %compare the signals

