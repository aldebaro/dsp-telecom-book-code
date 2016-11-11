Fs=8000; %sampling frequency
Ts=1/Fs; %sampling interval
N=1.5*Fs; %1.5 seconds
t=[0:N-1]*Ts;
if 1
    x = rand(1,N)-0.5; %zero mean uniformly distributed
else
    x = cos(2*pi*100*t); %cosine
end
delayInSamples=2000;
timeDelay = delayInSamples*Ts %delay in seconds
y=[zeros(1,delayInSamples) x(1:end-delayInSamples)];
SNRdb=10; %specified SNR
signalPower=mean(x.^2);
noisePower=signalPower/(10^(SNRdb/10));
noise=sqrt(noisePower)*randn(size(y));
y=y+noise;
subplot(211); plot(t,x,t,y);
[c,lags]=xcorr(x,y); %find crosscorrelation
subplot(212); plot(lags*Ts,c);
%find the lag for maximum absolute crosscorrelation:
L = lags(find(abs(c)==max(abs(c)))); 
estimatedTimeDelay = L*Ts

