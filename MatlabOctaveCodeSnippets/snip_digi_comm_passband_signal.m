N=10000; %number of samples
Fs=20e6; %sampling frequency in Hz
Ts=1/Fs; %sampling period in seconds
t=0:Ts:(N-1)*Ts; %discrete-time axis
x1=randn(1,N); %3 distinct white Gaussian noises
x2=randn(1,N); %with a band that ranges from 0 to 2*pi rad
x3=randn(1,N);
b=fir1(150,100e3/(Fs/2)); %cutoff frequency of 100 kHz
%Note fir1 defines the cutoff as the frequency of -6 dB
y1=filter(b,1,x1); %generate band-limited signals
y2=filter(b,1,x2);
y3=filter(b,1,x3);
c1=2*cos(2*pi*3e6*t); %carriers at 3, 5 and 8 MHz. 
c2=2*cos(2*pi*5e6*t); %Multiply by 2 to compensate that...
c3=2*cos(2*pi*8e6*t); %the impulses have area 1/2
zz=y1.*c1 + y2.*c2 + y3.*c3; %FDM signal
Pzz=pwelch(zz,[],[],[],Fs,'twosided'); %calculates the PSD
deltaF=Fs/length(Pzz); %interval in Hz
f=-Fs/2:deltaF:Fs/2-deltaF; %discretized frequency axis
plot(f,fftshift(10*log10(Pzz))); %negative and positive frequencies
