%Example of sinusoid plus noise
A=4; %sinusoid amplitude
noisePower=25; %noise power
f=2; %frequency in Hz
n=0:3999; %"time", using many samples to get good estimate
Fs=20; %sampling frequency in Hz
x=A*sin(2*pi*f/Fs*n); %generate discrete-time sine
randn('state', 0); %Set randn to its default initial state
z=sqrt(noisePower)*randn(size(x)); %generate noise
clf, subplot(211), plot(x+z); %plot noise
maxSample=100; %determine the zoom range
subplot(212),stem(x(1:maxSample)+z(1:maxSample)),pause; %zoom
maxLags = 20; %maximum lag for xcorr calculation
[Rx,lags]=xcorr(x,maxLags,'unbiased'); %signal only
[Rz,lags]=xcorr(z,maxLags,'unbiased'); %noise only
[Ry,lags]=xcorr(x+z,maxLags,'unbiased');%noisy signal
subplot(311), stem(lags,Rx); ylabel('R_x[l]');
subplot(312),stem(lags,Rz);ylabel('R_z[l]'); 
subplot(313),stem(lags,Ry);xlabel('Lag l');ylabel('R_y[l]');