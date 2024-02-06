Fs = 44100; %sampling frequency
Ts = 1/Fs; %sampling period
Timpulses = 0.25; %interval between impules in seconds
L=floor(Timpulses/Ts); %number of samples between impulses
N = 4; %number of impulses
impulseTrain=zeros(N*L,1); %allocate space with zeros
b=16; %number of bits per sample
amplitude = 2^(b-1)-1; %impulse amplitude, max signed int
impulseTrain(1:L:end)=amplitude; %generate impulses
writewav(impulseTrain,Fs,'impulses.wav','16r') %save WAVE RIFF

