symbols=[1 0 1 0 1 1 1 0];
L=48; 
upsampledSymbols=zeros(1,length(symbols)*L);
upsampledSymbols(1:L:end)=symbols;
p=ones(1,L);
xpam=conv(upsampledSymbols,p);
Fs=100;
n=0:length(xpam)-1;
t=n/Fs;

N=24;
carrier=cos(2*pi/N*n);
xask = xpam .* carrier;
subplot(223)
plot(t,xask)
axis tight
myaxis = axis;
xlabel('time (s)')
ylabel('ASK')

subplot(221)
plot(t,xpam)
myaxis(3)=-0.5;
myaxis(4)=1.5;
axis(myaxis);
ylabel('PAM')

subplot(222)
pwelch(xpam,[],[],[],Fs); %estimate PSD
title('')
xlabel('')
ylabel('PSD (dBW/Hz)')

subplot(224)
pwelch(xask,[],[],[],Fs); %estimate PSD
ylabel('PSD (dBW/Hz)')
title('')

writeEPS('pamvsask');