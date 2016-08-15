function [Cxx,alphas,lags] = ak_cyclicCorrelationEnsemble(X, ...
    alphaFFTLength)
%function [Cxx,alphas,lags] = ak_cyclicCorrelationEnsemble(X, ...
%   alphaFFTLength)
%Uses ensemble statistics. It does not assumes it is ergodic
%in the autocorrelation.
%Also called cyclic autocorrelation function (ACF)
[numSamplesOverTime,numRealizations]=size(X);

if nargin < 2
    alphaFFTLength=numSamplesOverTime;
elseif alphaFFTLength < numSamplesOverTime
    disp(['Warning: alphaFFTLength < numSamplesOverTime. ' ...
        'Truncating signal'])
    numSamplesOverTime = alphaFFTLength; %calculate only samples that
    %will be used
elseif alphaFFTLength > numSamplesOverTime
    disp(['Warning: alphaFFTLength > numSamplesOverTime. ' ...
        ' Using zero-padding (output values will be scaled)'])
end

%Rxx will have dimension numSamplesOverTime x numSamplesOverTime:
[Rxx,n1,n2]=ak_correlationEnsemble(X,numSamplesOverTime);
[newRxx,n,lags]=ak_correlationMatrixAsLags(Rxx,n1,n2);
%newRxx[n,lags] has the rows n=n1 of Rxx and the columns of newRxx
%are the lags=n2-n1. For example, newRxx(1,1) is the earliest time
%instant n=n1(1) with the smallest lag value.

%Calculate FFT for each column (lag), over time n, to find alpha:
Cxx=(1/alphaFFTLength)*fft(newRxx,alphaFFTLength);
%Cxx[alpha, lag] stores cycles per row and lags per column
%First row of Cxx has the DC values of each. Use fftshift to have
%the first row as the most negative cycle
Cxx = fftshift(Cxx,1); %Can later recover DC at first row with the...
%command Cxx = ifftshift(Cxx,1)

%Define alphas (cycles)
deltaAlpha=2/alphaFFTLength;
if rem(alphaFFTLength,2)==0 %even number
    alphas=pi*(-1:deltaAlpha:1-deltaAlpha);
else %odd number
    alphas=pi*(-1+deltaAlpha/2:deltaAlpha:1-deltaAlpha/2);
end

if nargout < 1
    mesh(lags,alphas,abs(Cxx));
    xlabel('lag'); ylabel('cycle \alpha'); zlabel('|Cx|')
end