function [n2,x2] = ak_normalize_histogram(y,numBins)
% function [pdf_approximating,abcissa] = ak_normalize_histogram(y,numBins)
%NORMHIST  Normalized histogram in order to compare with PDF of continuous
%random variables. y is the input vector and numBins the number of bins.
%
%Example:
%x=randn(1,10000);
%[n2,x2] = ak_normalize_histogram(x,100);
%a=-3:0.1:3;
%plot(x2,n2,a,normpdf(a))
%
%Aldebaro Mar. 2008
if nargin == 0
    error('Requires one or two input arguments.')
end
if nargin == 1
    numBins = 10;
end
[n2, x2]= hist(y,numBins);
range = max(x2)-min(x2);
binwidth = range / length(n2);
n2 = n2 / length(y) / binwidth;
