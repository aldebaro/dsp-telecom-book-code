B=[1 -0.8]; %MA filter coefficients
x=randn(1,10000); %generate white noise
y=filter(B,1,x); %generate MA(1) process
[Syy,f]=ak_psd(y,1); %find PSD via Welch's method
plot(f,Syy), hold on %plot estimated PSD
Hw=sum(abs(B).^2) + 2*B(1)*B(2)*cos(2*pi*f); %theoretical expression
plot(f,10*log10(Hw/1e-3),'r') %plot theoretical expression in dBm/Hz