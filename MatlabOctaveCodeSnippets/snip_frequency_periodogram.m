N=64; A=10; x=A*cos(2*pi/16*(0:N-1)); %generate cosine
BW=2*pi; %it is a discrete-time signal, assume BW = 2*pi
Sk = (1/(N*BW))*abs(fft(x)).^2; %Periodogram as defined in text
Power = (BW/N)*sum(Sk) %Obtain power from periodogram
Smatlab=periodogram(transpose(x)); %Octave requires column vector
M=length(Smatlab); %periodogram used zero-padding and unilateral PSD
Nfft=2*(M-1) %Nfft is the FFT-length adopted by Matlab/Octave
Power2= (BW/Nfft)*sum(Smatlab) %Power from periodogram function
subplot(211),stem(Sk),subplot(212),stem(Smatlab) %in linear scale