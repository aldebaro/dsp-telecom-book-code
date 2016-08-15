Rb=6; %symbols (bits in this case) per second
Tsym=1/Rb; %symbol period
N=100000; %number of symbols
x=rand(1,N)>=0.5; %convert to 0 or 1 amplitudes
x=2*(x-0.5); %convert to -1 or 1 amplitudes
oversampling=8; %oversampling factor
p=ones(oversampling,1); %mimics a NRZ pulse
s=zeros(N*oversampling,1); %pre-allocates
s(1:oversampling:end)=x; %s is the upsampling of x
s=filter(p,1,s); %implements the convolution: s is the line code
window=512; %window length
noverlap=[]; %overlapping, [] for Octave and Matlab compatibility 
fftsize=window; fs=oversampling*Rb;
%if you use below, the result is off by 3 dB:
%[P,f]=pwelch(s,window,noverlap,fftsize,fs,'onesided');
[P,f]=pwelch(s,window,noverlap,fftsize,fs,'twosided');
f=f(1:window/2); %f is from 0 to fs...
P=P(1:window/2); %keep only from 0 to fs/2
plot(f,10*log10(P),'r'); %plot the estimated PSD
polar=Tsym*sinc(f*Tsym).^2; % theoretical expression (A=1, B=1)
polardB = 10*log10(polar); hold on, plot(f,polardB,'b-x')

