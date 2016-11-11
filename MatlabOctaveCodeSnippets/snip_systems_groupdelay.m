h=[1.5 -2 5 -2 1.5]; %coefficients of symmetric FIR
N=8; %number of FFT points
Fs=44100; %sampling frequency (Hz)
H=fft(h,N); %calculate FFT of N points
f=Fs/N*(0:N/2); %create abscissa in Hz, where Fs/N is the bin width
p = unwrap(angle(H(1:N/2+1))); %calculate the phase in rad
plot(f,p), xlabel('f (Hz)'), ylabel('Phase (rad)'), pause
k1=2; k2=4; %choose two points of the line
%Calculate derivative as the slope. Convert from Hz to rad/s first:
groupDelay = -atan2(p(k2)-p(k1),2*pi*(f(k2)-f(k1))) %in seconds
groupDelayInSamples=round(2*groupDelay*Fs)/2; %quantize with step=0.5
grpdelay(h,1,f(1:N/2+1),Fs); %find delay for positive frequencies

