B=[1+3j -0.8-2j]; %MA highpass filter with complex coefficients
%B=[1 0.8]; %MA lowpass filter with real coefficients
x=randn(1,10000); %generate white noise
Px=mean(abs(x).^2) %input signal power
Fs=1; %Fs = BW = 1 Dhz to obtain discrete-time PSD
y=filter(B,1,x); %generate MA(1) process
[Syy,f]=ak_psd(y,Fs); %find PSD via Welch's method
plot(2*pi*f,Syy), hold on %plot estimated PSD in dBm/Dhz
Hmag2=(B(1)*conj(B(2))*exp(1j*2*pi*f))+sum(abs(B).^2)+ ...
    (conj(B(1))*B(2)*exp(-1j*2*pi*f));
plot(2*pi*f,10*log10(Hmag2/1e-3),'r')%theoretical, in dBm/Dhz
xlabel('\Omega (rad)'); ylabel('S(e^{j\Omega})  dBm/Dhz'), axis tight