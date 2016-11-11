x=[1:20,20:-1:1]; %input signal to be filtered, in Volts
[B,A]=butter(8,0.3); %IIR filter
h=impz(B,A,50); %truncate h[n] using 50 samples
y=conv(x,h);  %convolution y=x*h
x=x(:); y=y(:); %force both x and y to be column vectors
meanGroupDelay=5 %estimated "best" filter delay
y(1:meanGroupDelay)=[]; %compensate the filter delay
y(length(x)+1:end)=[]; %eliminate convolution tail
mse=mean( (x-y).^2 ) %calculate the mean squared error
SNR=10*log10(mean(x.^2)/mse) %estimate signal/noise ratio
stem(0:length(x)-1,x); hold on %input
stem(0:length(y)-1,y,'r') %output aligned with the input
stem(0:length(y)-1,x-y,'k') %e.g., calculate error after alignment

