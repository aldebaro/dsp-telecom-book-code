Fs=8000; %sampling frequency (Hz)
Ts=1/Fs; %sampling interval (seconds)
N=Fs * 14; %number of samples assuming a signal duration of 14 secs
n=0:N-1; %generate discrete-time abscissa
t=n*Ts; %discretized continuous-time axis (sec.)
t0=t(1:N/2); %first time segment
t1=t(N/2+1:end); %second time segment
f0=1000; %cosine frequency (Hz)
x0=500*cos(2*pi*f0*t0+0.3); %signal segment for first half
f1=3500; %cosine frequency (Hz)
x1=2*cos(2*pi*f1*t1+pi); %signal segment for first half
z=[x0 x1]; %concatenation of 2 cosines
[Z,f] = ak_spectrum(z, Fs); %spectrum for real-valued signals
subplot(211)
plot(f,20*log10(abs(Z)) + 30); %add 30 to convert dBW into dBm
ylabel('Magnitude (dBm)'), axis([0, Fs/2, -20, 100])
subplot(212) 
plot(f,angle(Z));
xlabel('Frequency (Hz)'); ylabel('Phase (rad)')
