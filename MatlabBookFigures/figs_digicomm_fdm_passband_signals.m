%used frequency division multiplexing (FDM) to generate
%three signals mimicking GSM channels.
clf
rand('twister',0); %reset uniform random number generator
randn('state',0); %reset Gaussian random number generator
N=10000; %number of samples
Fs=20e6; %sampling frequency in Hz
Ts=1/Fs; %sampling period in seconds
t=0:Ts:(N-1)*Ts; %discrete-time axis
x1=randn(1,N); %3 distinct white Gaussian noises
x2=randn(1,N); %all 3 have a band that ranges from 0 to 2*pi rad
x3=randn(1,N);
b=fir1(150,100e3/(Fs/2)); %filter with cutoff frequency of 100 kHz
%Note that fir1 defines the cutoff as the frequency of -6 dB
y1=filter(b,1,x1); %generate band-limited signals
y2=filter(b,1,x2);
y3=filter(b,1,x3);
c1=2*cos(2*pi*3e6*t); %carriers at 3, 5 and 8 MHz. 
c2=2*cos(2*pi*5e6*t); %Multiply by 2 to compensate that...
c3=2*cos(2*pi*8e6*t); %the impulses have area 1/2
zz=y1.*c1 + y2.*c2 + y3.*c3; %FDM signal
Pxx=pwelch(x1,[],[],[],Fs,'twosided'); %calculates x1 PSD
deltaF=Fs/length(Pxx); %interval in Hz
f=-Fs/2:deltaF:Fs/2-deltaF; %discretized frequency axis
[indices]=find(abs(abs(f)-3e6)<deltaF/2); %find 2 specific points
subplot(311);
h=plot(f,fftshift(10*log10(Pxx))); %plot negative and positive frequencies
ylabel('PSD (dB/Hz)'); grid
%makedatatip(h,1); %illustrate Hermitian symmetry
subplot(312);
Pyy=pwelch(y2,[],[],[],Fs,'twosided'); %calculates y2 PSD
h=plot(f,fftshift(10*log10(Pyy))); %plot negative and positive frequencies
ylabel('PSD (dB/Hz)'); grid
%makedatatip(h,1); %illustrate Hermitian symmetry
subplot(313);
Pxx=pwelch(y2.*c2,[],[],[],Fs,'twosided'); %calculates upconverted PSD
h=plot(f,fftshift(10*log10(Pxx))); %plot negative and positive frequencies
ylabel('PSD (dB/Hz)'); grid
makedatatip(h,indices); %illustrate Hermitian symmetry
writeEPS('passband_signal_creation','font12Only')

clf
Pzz=pwelch(zz,[],[],[],Fs,'twosided'); %calculates the PSD
h = plot(f,fftshift(10*log10(Pzz))); %plot negative and positive frequencies
xlabel('f (Hz)'); ylabel('PSD (dB/Hz)'); grid
makedatatip(h,indices); %illustrate Hermitian symmetry
writeEPS('three_passband_signals','font12Only')