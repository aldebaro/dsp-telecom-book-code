x=[3 0 4 0 5]; %some signal samples
y=fliplr(x); %time-reversal
n1=0:4; %the 'time' axis
n2=-4:0; %the 'time-reversed' axis
subplot(211); stem(n1,x); title('x[n]'); 
subplot(212); stem(n2,y); title('y[n]'); 

