N=1024; n=(0:N-1)'; %number of samples and column vector
dw=2*pi/N; %FFT bin width
A=10; x=A*cos((2*pi/64)*n); %generate cosines with period 64
Sms = abs(fft(x)/N).^2; %MS spectrum |DTFS{x}|^2
S = abs(fft(x)).^2/N; %Periodogram (|FFT{x}|^2)/N
%% 1) Obtain Sms from periodogram
Sms2=S/N; %Example of obtaining MS spectrum from periodogram
%% 2) Alternatives for computing power (power in Watts = A^2/2)
Power = sum(Sms) %a) from the MS spectrum 
Power2 = 1/(2*pi)*(sum(S)*dw) %b) assuming discrete-time PSD
Fs = 1; %c) assuming continuous -time PSD (Fs is 1 Hz)
df = Fs/N; %In this case c), bin width is df = 1/N Hz
Power3 = df * sum(S) %Power = Power2 = Power3 = 50 Watts 