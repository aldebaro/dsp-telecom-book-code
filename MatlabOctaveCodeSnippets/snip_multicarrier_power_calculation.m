N=4096; %FFT size
K=2004; %# tones that can be used
Fs = 211.968e6; %sampling frequency
BW = Fs/2; %bandwidth
sk_dB = -76 %PSD (dBm/Hz)
sk = 10^(0.1*sk_dB)*1e-3 %PSD (W/Hz)
deltaF = 51.75e3; %tone spacing
Pk = sk * deltaF; %power at tone k
Pd1=BW * sk *1000 %first order Tx power estimation (mW)
Pd2=K*sum(Pk)*1000 %more realistic Tx power estimation (mW)
%% just to play with signal generation
X=sqrt(Pd2)*randn(1,N); %generate random signal with given power
x=sqrt(N)*ifft(X); %go to time-domain
mean(abs(X).^2) %compare the squared norms
mean(abs(x).^2)
