N = 3000; %total number of signal samples
Nfft = 32; %segment length M and also FFT-length
Fs = 1; %assumed bandwidth for discrete-time signal
power_x = 600; %noise power in Watts
x=sqrt(power_x) * randn(1,N); %Gaussian white noise
[Sk,F]=pwelch(x,hamming(Nfft),[],Nfft,Fs,'twosided'); %Parameter []
%is because in Matlab it is num. samples while Octave is percent (%)
disp(['Periodogram standard deviation=' num2str(std(Sk))])
plot(2*pi*F,Sk) %periodogram with Fs=1 is discrete-time PSD
hold on, plot(w,power_x*ones(1,length(w)),'r') %PSD theoretical value