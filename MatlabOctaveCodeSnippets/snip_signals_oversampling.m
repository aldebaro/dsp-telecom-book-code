Fs=8000; %sampling frequency (Hz)
Ts=1/Fs; %sampling interval (seconds)
f0=2400; %cosine frequency (Hz)
N=40; %number of desired samples
n=0:N-1; %generate discrete-time abscissa
t=n*Ts; %discretized continuous-time axis (sec.)
x=6*cos(2*pi*f0*t); %amplitude=6 V and frequency = f0 Hz
subplot(211), plot(t,x); %plot discrete-time signal
%% Create an oversampled version of signal x
oversampling_factor = 200;
oversampled_Ts = Ts/oversampling_factor;
oversampled_n = n(1)*oversampling_factor:n(end)*oversampling_factor;
oversampled_t=oversampled_n*oversampled_Ts;%oversampled discrete-time 
xo=6*cos(2*pi*f0*oversampled_t); %oversampled discrete-time signal
subplot(212), plot(oversampled_t,xo);