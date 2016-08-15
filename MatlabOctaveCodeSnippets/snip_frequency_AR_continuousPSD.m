N=100000; x=randn(1,N); %WGN with zero mean and unit variance
Fs=600; %assumed sampling frequency in Hz
y=filter(4,[1 0.5 0.98],x); %realization of an AR(2) process
[A,Perror]=lpc(y,2) %estimate filter via LPC
pwelch(y,[],50,2048,Fs); %plot PSD estimate (continuous-time)
[H,w]=freqz(1,A,2048); %get frequency response of H(z)
Shat=(Perror/Fs)*(abs(H).^2); %get PSD estimated via AR model
Shat=2*Shat; %convert to unilateral PSD (DC value is doubled here)
hold on, plot(w*Fs/(2*pi),10*log10(Shat),'k') %compare in dB