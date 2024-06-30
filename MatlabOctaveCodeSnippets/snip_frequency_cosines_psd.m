N=128; n=(0:N-1)'; %number of samples and column vector
Fs=2000; %bandwidth in Hertz, equivalent to sampling frequency
dW=(2*pi)/N; %FFT bin width in radians, to define cosines
k1=N/4; k2=N/8; W1=k1*dW; W2=k2*dW;%define frequencies in radians
x=10*cos(W1*n) + 1*cos(W2*n); %create sum of bin-centered cosines
Sdef = (abs(fft(x)).^2)/(N*Fs); %periodogram via its definition
Sdef = [Sdef(1); 2*Sdef(2:N/2); Sdef(N/2+1)]; %convert to unilateral
[S,f] = periodogram(x,rectwin(N),N,Fs); %using periodogram function
Power_freq=(Fs/N)*sum(S) %estimate power (watts) in frequency domain
Power_time=mean(x.^2) %estimate power (watts) in time domain
h=plot(f,10*log10(Sdef),'-x'); hold on
h2=plot(f,10*log10(S),'-ro'); %Periodogram (dB scale)
legend('via definition','via Matlab')
xlabel('f (Hz)'), ylabel('S(f) (dBW/Hz)')
%use w=W Fs to convert to f in Hz and show datatips (f=W*Fs/(2*pi))
f1=W1*Fs/(2*pi); f2=W2*Fs/(2*pi); %frequencies in Hz
datatip(h,f1,Sdef(k1)); datatip(h,f2,Sdef(k2));