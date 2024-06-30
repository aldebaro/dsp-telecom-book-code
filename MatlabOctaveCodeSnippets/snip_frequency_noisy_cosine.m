N=1024; A=4; %# of samples and cosine amplitude of A Volts
Fs=8000; Ts=1/Fs; %sampling frequency (Hz) and period (s)
f0=915; %cosine frequency in Hz
noisePower=16; %noise power in Watts
noise=sqrt(noisePower)*randn(1,N);
t=0:Ts:(N-1)*Ts; %N time instants separated by Ts
x=A*cos(2*pi*f0*t) + noise;%generate cosine with AWGN
[P,f]=periodogram(x,[],N,Fs); %periodogram (using the default window)
plot(f,10*log10(P)); %plot in dB scale