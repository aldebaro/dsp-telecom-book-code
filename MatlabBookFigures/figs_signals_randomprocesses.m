clear all
clf
%use the state method for number generation and set seed to 1
randn('state',1);
N=100; %number of random samples
x=randn(1,N); %generate samples according to Gaussian distribution

plot(0:N-1, x);
xlabel('n'); ylabel('x[n]');
writeEPS('zeromean_randomsignal');

hist(x) %plot histogram with default values (e.g., 10 bins)
xlabel('x'); ylabel('# occurrences');
writeEPS('simple_histogram');

%use function that normalizes histogram
B=10; %number of bins
[n2,x2] = ak_normalize_histogram(x,B);
%use range of [-3std, 3std] around the mean:
a=-3:0.1:3;
plot(x2,n2,'o-',a,octave_normpdf(a),'x-')
xlabel('x'); ylabel('likelihood');
legend('normalized histogram','Gaussian')
writeEPS('normalized_simple_histogram');

%with more samples, larger number of bins, new mean and variance
newMean=4;
newVariance=0.09;
N=10000; %number of random samples
x=sqrt(newVariance)*randn(1,N)+newMean;
B=100; %number of bins
[n2,x2] = ak_normalize_histogram(x,B);
a=newMean+(-3:0.1:3)*sqrt(newVariance);
plot(x2,n2,'o-',a,octave_normpdf(a,newMean,sqrt(newVariance)),'x-')
xlabel('x'); ylabel('likelihood');
legend('normalized histogram','Gaussian')
grid
writeEPS('normalized_histogram');

