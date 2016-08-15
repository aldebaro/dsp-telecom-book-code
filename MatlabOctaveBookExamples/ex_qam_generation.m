%generate QAM signal with 200 kHz of BW centered at 2 MHz
N=10000; %number of samples
Fs=20e6; %sampling frequency in Hz
Ts=1/Fs; %sampling period in seconds
t=0:Ts:(N-1)*Ts; %discrete-time axis
x1=randn(1,N); %white Gaussian noise
x2=randn(1,N); %white Gaussian noise
b=fir1(50,100e3/(Fs/2)); %cutoff frequency of 100 kHz
%(fir1 defines the cutoff as the frequency of -6 dB)
y1=filter(b,1,x1); %filter both signals such that...
y2=filter(b,1,x2); %they have BW=100 kHz
%1) generate QAM using the straightforward way
carrier_i=cos(2*pi*2e6*t); %create two carriers at 2 MHz
carrier_q=sin(2*pi*2e6*t); %carrier in quadrature
z=y1.*carrier_i + y2.*carrier_q; %modulated QAM signal
%2) version of QAM generation using complex signals
yce=y1-j*y2; %complex envelope at baseband: note the minus
carrier=exp(j*2*pi*2e6*t); %complex carrier: cos + j * sin
z2=real(yce.*carrier); %you can compare z2 with z