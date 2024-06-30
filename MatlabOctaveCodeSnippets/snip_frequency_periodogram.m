N=16; alpha=2; A=10; n=0:N-1;
x=A*cos((2*pi*alpha/N)*n); %generate cosine
x=x(:); %Octave requires column vector
BW=1; %it is a discrete-time signal, then assume BW=1 Hz
Sk = (1/(N*BW))*abs(fft(x)).^2; %Periodogram as defined in textbook
Power = (BW/N)*sum(Sk) %Obtain power from periodogram
Smatlab=periodogram(x,[],N,BW,'twosided'); %angular frequency in rad
M=length(Smatlab); %periodogram used zero-padding and unilateral PSD
Power2= (BW/N)*sum(Smatlab) %Power from periodogram function
%W= (2*pi/N)*(-N/2:(N/2-1)); %discrete frequency axis in radians
W= (2*pi/N)*(0:N-1); %discrete frequency axis in radians
clf; subplot(211); h=stem(W,Smatlab);
hold on; stem(W,Sk,'xr')
Npad=512; %use zero-padding to increase number of points to 253
[Smatlab,W]=periodogram(x,[],Npad,BW,'twosided'); %angular freq. in rad
subplot(212); stem(2*pi*W,Smatlab)
xlabel('\Omega (rad)'); ylabel('S(e^{\Omega})  (W/dHz)');
datatip(h,2*pi/N,((A^2/2)/2)/(BW/N))
%second figure
subplot(212);
[Smatlab,f]=periodogram(x,[],[],BW,'twosided'); %zero-padding
h=stem(2*pi*f,Smatlab,'xr');
xlabel('\Omega (rad)'); ylabel('S(e^{\Omega})  (W/dHz)');
datatip(h,2*pi/8,((A^2/2)/2)/(BW/N))
axis tight
