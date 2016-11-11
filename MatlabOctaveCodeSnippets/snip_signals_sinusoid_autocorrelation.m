numSamples = 48; %number of samples
n=0:numSamples-1; %indices
N = 8; %sinusoid period
x=4*sin(2*pi/N*n); %sinusoid (try varying the phase!)
[R,l]=xcorr(x,'unbiased'); %calculate autocorrelation
subplot(211); stem(n,x); xlabel('n');ylabel('x[n]');
subplot(212); stem(l,R); xlabel('Lag l');ylabel('R_x[l]');

