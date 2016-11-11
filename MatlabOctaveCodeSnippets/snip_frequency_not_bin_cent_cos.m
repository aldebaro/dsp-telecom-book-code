N=1024; n=(0:N-1)'; %number of samples and column vector
dw=2*pi/N; %FFT bin width
k1=115.3; k2=500.8; w1=k1*dw; w2=k2*dw;%define frequencies
x=10*cos(w1*n) + 1*cos(w2*n); %generate sum of two cosines
Sms = abs(fft(x)/N).^2; %MS spectrum |DTFS{x}|^2
[S,w] = periodogram(x); %Periodogram, frequency w=0 to pi
Power = sum(Sms) %estimate the power in Watts = A^2/2
k=0:N-1; %frequency index
subplot(211), h=plot(k,10*log10(Sms)); %MS spectrum (dB)
subplot(212), h2=plot(w,10*log10(S)); %Periodogram (dB)