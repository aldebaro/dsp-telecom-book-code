N = 3000; %total number of signal samples
L = 4; %number of non-zero samples of h[n]
power_x = 600; %noise power in Watts
x=sqrt(power_x) * randn(1,N); %Gaussian white noise
h=ones(1,L); %shaping pulse with square waveform
y=conv(h,x); %filter signal x with filter
Nfft = 256; %segment length M and also FFT dimension
Fs = 2*pi; %sampling frequency for discrete-time PSD
[Sy_pwelch,w]=pwelch(y,hamming(Nfft),[],Nfft,Fs,'twosided');
H=fft(h,4*N); %DTFT (sampled) of the impulse response
Sy_th=power_x*abs(H).^2; %PSD theoretical expression
plot(w,2*pi*Sy_pwelch); hold on %scale by 2*pi to get disc.time PSD
plot(linspace(0,2*pi,length(H)),power_x*abs(H).^2,'r')