B=10; %number of bins
x=randn(1,100); %random numbers ~ G(0,1)
[n2,x2]=ak_normalize_histogram(x,B);%PDF via normalized histogram
a=-3:0.1:3; %use range of [-3std, 3std] around the mean
plot(x2,n2,'o-',a,normpdf(a),'x-') %estimate vs. theoretical PDF

