N=1000; x=randn(1,N); %WGN with zero mean and unit variance
Px=mean(abs(x).^2) %input signal power
B=4; %filter numerator
A=[1 0.5 0.98]; %filter denominator
Fs=1; %sampling frequency Fs = BW = 1 DHz
y=filter(B,A,x); %realization of an AR(2) process
Py=mean(abs(y).^2) %output power
for P=1:4 %vary the filter order
    [Sy,f]=pwelch(y,rectwin(N),[],N,Fs,'twosided'); 
    [Hthe,w]=freqz(B, A,'twosided');
    [Ahat,Perror]=aryule(y,P) %estimate filter of order P
    [Hhat,w]=freqz(sqrt(Perror), Ahat,'twosided');
    clf, plot(2*pi*f,10*log10(Sy),'r'); hold on
    plot(w,10*log10(Px*abs(Hthe).^2),'k--');
    plot(w,10*log10(Px*abs(Hhat).^2),'b');
    legend('Welch','Theoretical','AR')
    pause
end

