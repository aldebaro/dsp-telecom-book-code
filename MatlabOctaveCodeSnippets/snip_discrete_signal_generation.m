Fs=8000; %sampling frequency (Hz)
Ts=1/Fs; %sampling interval (seconds)
f0=400; %cosine frequency (Hz)
N=100; %number of desired samples
n=0:N-1; %generate discrete-time abscissa
t=n*Ts; %discretized continuous-time axis (sec.)
x=6*cos(2*pi*f0*t); %amplitude=6 V and frequency = f0 Hz
stem(n,x); %plot discrete-time signal

