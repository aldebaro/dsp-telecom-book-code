function [Rxx_tau, lags] = ak_convertToWSSCorrelation(Rxx)
% function [Rxx_tau,lags]=ak_convertToWSSCorrelation(Rxx)
%Convert Rxx[n1,n2] into Rxx[k], assuming process is 
%wide-sense stationary (WSS).
%Input: Rxx -> matrix with Rxx[n1,n2]
%Outputs: Rxx_tau[lag] and lag=n2-n1.
[M,N]=size(Rxx); %M is assumed to be equal to N
lags=-N:N; %lags
numLags = length(lags); %number of lags
Rxx_tau = zeros(1,numLags); %pre-allocate space
for k=1:numLags;
    lag = lags(k); counter = 0; %initialize
    for n1=1:N
        n2=n1+lag; %from: lag = n2 - n1
        if n2<1 || n2>N %check
            continue; %skip if out of range
        end
        Rxx_tau(k) = Rxx_tau(k) + Rxx(n1,n2); %update
        counter = counter + 1; %update
    end
    if counter ~= 0
        Rxx_tau(k) = Rxx_tau(k)/counter; %normalize
    end
end
