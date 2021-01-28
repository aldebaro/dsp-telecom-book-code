B=[1 -0.8]; %MA filter coefficients
B=ones(1,10);
x=randn(1,10000); %generate white noise
Fs=1; %Fs = BW = 1 Hz to obtain discrete-time PSD
y=filter(B,1,x); %generate MA(1) process
[Syy,f]=ak_psd(y,Fs); %find PSD via Welch's method
plot(2*pi*f,Syy), hold on %plot estimated PSD in dBm/Dhz
Hw=sum(abs(B).^2) + 2*B(1)*B(2)*cos(2*pi*f); %theoretical expression
plot(2*pi*f,10*log10(Hw/1e-3),'r') %theoretical expression in dBm/Dhz
xlabel('\Omega (rad)'); ylabel('S(e^{j\Omega})  dBm/Dhz'), axis tight