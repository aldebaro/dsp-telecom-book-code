N=1024; A=10; x=A*cos(2*pi/64*(0:N-1));%generate cosine
dw = 2*pi/N; %FFT bin width
%First alternative: use the definition
S = abs(fft(x)).^2/N; %Periodogram (|FFT{x}|^2)/N
Power = 1/(2*pi)*(sum(S)*dw) %Alternative, power from PSD
%First alternative: use the periodogram function
[P,w]=periodogram(transpose(x));%Octave: use column vector
Power2=sum(P)*dw %calculate again, to compare with Power
subplot(211), h=plot(P), ylabel('S[k]'); %linear scale, then dB x w:
subplot(212),h2=plot(w,10*log10(P)),ylabel('S[k] (dB)'),xlabel('k')


