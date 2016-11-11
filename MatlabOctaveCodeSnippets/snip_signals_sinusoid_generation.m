Fs=8000; %sampling frequency (Hz)
Ts=1/Fs; %sampling interval (seconds)
N=20000; %number of desired samples
f0=600; %cosine frequency (Hz)
%%%%First alternative to generate a cosine of 600 Hz
t=0:Ts:(N-1)*Ts; %discretized continuous-time axis (sec.)
x1=5*cos(2*pi*f0*t); %amplitude=5 V and frequency = f0 Hz
%%%%Second alternative: work directly in discrete-time
w0=2*pi*f0*Ts; %w0 is in rad, convert from rad/s to rad
n=0:N-1; %discrete-time axis (do not use Ts anymore)
x2=5*cos(w0*n); %amplitude=5 V and frequency = w0 rad
plot(x1-x2); %plot error between two alternative sequences
soundsc(x1,Fs) %for fun: playback one of them to listen

