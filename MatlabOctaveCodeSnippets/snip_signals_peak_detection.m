load sunspot.dat; %the data file
year=sunspot(:,1); %first column
wolfer=sunspot(:,2); %second column
%plot(year,wolfer); title('Sunspot Data') %plot raw data
x=wolfer-mean(wolfer); %remove mean
[R,lag]=xcorr(x); %calculate autocorrelation
plot(lag,R); hold on;
index=find(lag==11); %we know the 2nd peak is lag=11
plot(lag(index),R(index),'r.', 'MarkerSize',25);
text(lag(index)+10,R(index),['2nd peak at lag=11']);

