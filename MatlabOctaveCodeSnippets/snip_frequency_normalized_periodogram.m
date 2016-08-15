N=1024; A=10; x=A*cos(2*pi/64*(0:N-1));%generate cosine
Fs=8000; %sampling frequency in Hz
rectWindow=rectwin(N); %rectangular window
rectWindow=rectWindow(:); x=x(:); %make sure both are column vectors
[P,f]=periodogram(x,rectWindow,N,Fs); %periodogram 
df = Fs/N; %FFT bin width to be used in power computation
Power=sum(P)*df %calculate the average power
plot(f/1000,10*log10(P)); grid, %convert to dBW/Hz
