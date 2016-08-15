function EVMrms = ak_evm(referenceSignal, otherSignal, normalize)
% function EVMrms = ak_evm(referenceSignal, otherSignal, normalize)
%Calculate RMS Error Vector Magnitude (EVM) in %. In case normalize
%is 1, force otherSignal to have the same power as referenceSignal.
%The output is the mean square value of 
%  error = referenceSignal - otherSignal
%normalized by the mean square value of referenceSignal times 100.
if nargin < 3
    normalize=0;
end
refSignalPower=mean(abs(referenceSignal).^2);
if normalize==1
    otherSignal=sqrt(refSignalPower / mean(abs(otherSignal).^2))* ...
        otherSignal;
end
error = referenceSignal - otherSignal;
mse = mean(abs(error).^2);
EVMrms = sqrt(mse/refSignalPower)*100;
%See,e.g., http://www.mathworks.com/help/comm/ref/evmmeasurement.html