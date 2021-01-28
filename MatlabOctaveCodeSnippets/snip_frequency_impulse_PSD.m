N=5; %number of FFT points
M=2; %maximum number of autocorrelation lags
BW=1; %BW in normalized frequency (digital Hertz)
x=[6 0 0 0 0]; %impulse signal truncated in N samples
Sms=abs(fft(x)/N).^2 %MS spectrum: all values are 2.25 Watts
Sk=periodogram(x,[],length(x),1,'twosided') %periodogram
[R,lags]=xcorr(x,M,'biased'); %estimating autocorrelation
Sxcorr=abs(fft(R)); %PSD via autocorrelation
Power=sum(Sms) %power (9 W) obtained from MS spectrum
Power2=(BW/N)*sum(Sk) %power (9 W) from 
Power3=(BW/N)*sum(Sxcorr) %power (9 W) from periodogram via xcorr

