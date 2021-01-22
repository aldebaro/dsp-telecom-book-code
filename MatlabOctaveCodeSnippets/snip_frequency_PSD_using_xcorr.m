N = 3000; %total number of signal samples
L = 4; %number of non-zero samples of h[n]
power_x = 600; %noise power in Watts
x=sqrt(power_x) * randn(1,N); %Gaussian white noise
h=ones(1,L); %FIR moving average filter impulse response
y=conv(h,x); %filtered signal y[n] = x[n] * h[n]
H=fft(h,4*N); %DTFT (sampled) of the impulse response
Sy_th=power_x*abs(H).^2; %theoretical PSD via sampling DTFT
M=256; %maximum lag chosen as M < N
[Ry,lags]=xcorr(y,M,'biased'); %estimating autocorrelation
Sy_corr=abs(fft(Ry)); %PSD estimate via autocorrelation
