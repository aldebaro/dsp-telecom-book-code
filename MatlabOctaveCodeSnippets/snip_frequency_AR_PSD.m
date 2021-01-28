N=100000; x=randn(1,N); %WGN with zero mean and unit variance
y=filter(4,[1 0.5 0.98],x); %realization of an AR(2) process
[A,Perror]=aryule(y,2) %estimate AR filter via LPC
noverlap=50; Nfft=2048; Fs=1; %pwelch input values
[Sp,f]=pwelch(y,[],noverlap,Nfft,Fs,'twosided');%PSD
%Sp = 2*pi*Sp; %convert estimation into discrete-time PSD
[H,w]=freqz(1,A,2048,'whole'); %get frequency response of H(z)
Shat=Perror*(abs(H).^2); %get PSD estimated via autoregressive model
plot(2*pi*f,10*log10(Sp),w,10*log10(Shat)) %compare in dB
xlabel('\Omega (rad)'); ylabel('S(e^{j\Omega})  dBW/Dhz'), axis tight