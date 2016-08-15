clear all, close all
%design digital Bandpass Elliptic filter
Apass=5; %maximum ripple at passband
Astop=80; %minimum attenuation at stopband
Fs=500; % sampling frequency
Wr1=10/(Fs/2); 
Wp1=20/(Fs/2); 
Wp2=120/(Fs/2);
Wr2=140/(Fs/2);

[N, Wp] = ellipord([Wp1 Wp2], [Wr1 Wr2], Apass, Astop) %find order
[z,p,k]=ellip(N,Apass,Astop,Wp); %design digital Elliptic filter
[B, A]=zp2tf(z,p,k); %convert zp to transfer function

%[B, A] = bilinear(Bs, As, 2);

%study the quantization of filter coefficients
% the number b of bits is b = is + ds + 1
is=4; % number of bits for integer part
ds=5; % number of bits for decimal part

Bq=fixed(is,ds,B);
Aq=fixed(is,ds,A);

zplane(B,A);
plot(real(Bq),imag(Bq),'x')