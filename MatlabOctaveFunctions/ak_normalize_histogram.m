function [pdf_approximation,abcissa] = ak_normalize_histogram(y,numBins)
% function [pdf_approximation,abcissa] = ak_normalize_histogram(y,numBins)
%Provides an estimated probability density function (PDF) based on
%normalizing a histogram. Inputs:
%y is the input vector and numBins the number of bins.
%
%Example:
%x=randn(1,10000);
%[n2,x2] = ak_normalize_histogram(x,100);
%a=-3:0.1:3;
%plot(x2,n2,a,normpdf(a))
%
%Aldebaro. 2022
if nargin == 0
    error('Requires one or two input arguments.')
end
if nargin == 1
    numBins = 10;
end
[pdf_approximation, abcissa]= hist(y,numBins);
range = max(abcissa)-min(abcissa);
binwidth = range / length(pdf_approximation);
pdf_approximation = pdf_approximation / (length(y) * binwidth);
