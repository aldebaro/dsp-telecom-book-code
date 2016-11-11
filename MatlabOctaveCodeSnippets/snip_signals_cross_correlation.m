x=1:3; %some signal
y=[(3:-1:1) x]; %the other signal
[c,lags]=xcorr(x,y); %find cross-correlation
max(c) %show the maximum cross-correlation value
L = lags(find(c==max(c))) %lag for max cross-correlation
stem(lags,c); %plot
xlabel('lag (samples)'); ylabel('cross-correlation') 

