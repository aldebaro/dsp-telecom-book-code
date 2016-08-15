N=4; %number of FFT points
x=[6 0 0 0]; %impulse signal truncated in N samples
Sms=abs(fft(x)/N).^2 %MS spectrum: all values are 2.25 Watts
Spsd=abs(fft(x)).^2/N %PSD (9 W/rad) differs from periodogram by 2*pi
Sk=periodogram(x,[],length(x)) %periodogram with N-length window
Power=sum(Sms) %average power (9 Watts) obtained from MS spectrum
Power2=(1/N)*sum(Spsd) %average power (9 Watts) from PSD
Power3=(2*pi/N)*sum(Sk) %average power (9 Watts) from periodogram