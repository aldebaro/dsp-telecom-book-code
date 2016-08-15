power=8; %Watts
N=10000; %number of samples
x=sqrt(power)*randn(1,N); %white noise signal
Fs=40; maxLag=100; %sampling frequency and maximum lag
[R,l]=xcorr(x,x,maxLag,'biased'); %biased autocorrelation
stem(l,R);xlabel('lag l');ylabel('autocorrelation R[l]');

