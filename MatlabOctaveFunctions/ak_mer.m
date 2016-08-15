function MERdB = ak_mer(referenceSignal, otherSignal)
% function MERdB = ak_mer(referenceSignal, otherSignal)
%Calculate the  Modulation Error Ratio (MER), which is a measure of
%the signal-to-noise ratio (SNR) in digital modulation applications.
error = referenceSignal - otherSignal;
mse = mean(abs(error).^2);
MERdB = 10*log10(mean(abs(referenceSignal).^2)/mse);
%See,e.g., http://www.mathworks.com/help/comm/ref/mermeasurement.html