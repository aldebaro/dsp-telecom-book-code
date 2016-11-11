x=[1 -2 3 4 5 -1]; %some signal
y=[3 1 -2 -2 1 -4 -3 -5 -10]; %the other signal
[c,lags]=xcorr(x,y); %find crosscorrelation
L = lags(find(abs(c)==max(abs(c)))); %lag for the maximum
if L>0
	x(1:L)=[]; %delete first L samples from x
else
	y(1:-L)=[]; %delete first L samples from y
end
if length(x) > length(y) %make sure lengths are the same
	x=x(1:length(y));
else
	y=y(1:length(x));
end
plot(x-y); title('error between aligned x and y');

