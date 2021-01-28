N=100000; x=randn(1,N); %WGN with zero mean and unit variance
Fs=600; %assumed sampling frequency in Hz
y=filter(4,[1 0.5 0.98],x); %realization of an AR(2) process
[A,Perror]=lpc(y,2) %estimate filter via LPC
noverlap=50; Nfft=2048; %pwelch input values
pwelch(y,[],noverlap,Nfft,Fs);% continuous-time PSD
[H,w]=freqz(1,A,Nfft); %get frequency response of H(z)
N0div2=Perror/Fs; %white noise PSD level is power / bandwidth
Shat=N0div2*(abs(H).^2); %get PSD estimated via AR model
Shat=[Shat(1); 2*Shat(2:end-1); Shat(end)]; %convert to unilateral
hold on, plot(w*Fs/(2*pi),10*log10(Shat),'k') %compare in dB