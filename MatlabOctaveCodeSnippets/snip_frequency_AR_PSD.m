N=100000; x=randn(1,N); %WGN with zero mean and unit variance
y=filter(4,[1 0.5 0.98],x); %realization of an AR(2) process
[A,Perror]=lpc(y,2) %estimate filter via LPC
[Sp,w]=pwelch(y,[],50,2048,'twosided');%PSD (assumes continuous-time)
Sp = 2*pi*Sp; %convert estimation into discrete-time PSD
[H,w]=freqz(1,A,2048,'whole'); %get frequency response of H(z)
Shat=Perror*(abs(H).^2); %get PSD estimated via autoregressive model
plot(w/pi,10*log10(Sp),w/pi,10*log10(Shat)) %compare in dB