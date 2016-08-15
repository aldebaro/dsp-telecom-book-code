N=1024; A=10; x=A*cos(2*pi/64*(0:N-1));%generate cosine
Fs=8000; %sampling frequency
rectWindow=boxcar(N); %rectangular window
rectWindow=rectWindow(:); x=x(:); %make sure both are column vectors
df = Fs/N; %FFT bin width
[P,w]=periodogram(x,rectWindow,N,Fs); %periodogram 
Power=sum(P)*df %calculate again, to compare with Power
plot(w,P); %linear scale
xlabel('f (Hz)'), ylabel('S(f)'), %graph in Hz

