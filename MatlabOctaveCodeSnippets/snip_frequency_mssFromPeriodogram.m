N=1024; n=(0:N-1)'; %number N of samples and column vector n
A=10; x=A*cos((2*pi/64)*n); %generate cosine with period 64
Sms = abs(fft(x)/N).^2; %MS spectrum |DTFS{x}|^2
BW = 2*pi; %assumed bandwidth is 2*pi
S = abs(fft(x)).^2/(BW*N); %Periodogram (|FFT{x}|^2)/(BW * N)
Sms2=BW*S/N; %Example of obtaining MS spectrum from periodogram
Power = sum(Sms) %Obtaining power from the MS spectrum 
Power2 = sum(S)*BW/N %Obtaining power from the periodogram