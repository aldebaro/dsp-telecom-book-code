N=16; alpha=2; A=10; n=0:N-1;
x=A*cos((2*pi*alpha/N)*n); %generate cosine
x=x(:); %Octave requires column vector
BW=1; %it is a discrete-time signal, assume BW=1 Hz
Sk = (1/(N*BW))*abs(fft(x)).^2; %Periodogram as defined in text
Power = (BW/N)*sum(Sk) %Obtain power from periodogram
Smatlab=periodogram(x,[],N,BW,'twosided'); %from f=0 to 1 dHz
M=length(Smatlab); %periodogram used zero-padding and unilateral PSD
dhertz = (1/N)*(-N/2:(N/2-1)); %normalized frequency
Power2= (BW/N)*sum(Smatlab) %Power from periodogram function
W=2*pi*dhertz; %convert abscissa to Omega in radians
clf; subplot(211); h=stem(W,fftshift(Smatlab));
hold on; stem(W,fftshift(Sk),'xr')
