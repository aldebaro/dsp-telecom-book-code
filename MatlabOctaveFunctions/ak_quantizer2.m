function [x_q,x_i,quantizerLevels,partitionThresholds] = ...
    ak_quantizer2(x,b,xmin,xmax,forceZeroLevel)
%function [x_q,x_i,quantizerLevels]=ak_quantizer2(x,b,xmin,xmax,...
%    forceZeroLevel)
%Note that x_i has values from 0 to (2^b)-1.
if nargin < 3 %use default values
    xmin=min(x);
    xmax=max(x);
    forceZeroLevel=0;
end
M=2^b; %number of quantization levels
delta=abs((xmax-xmin)/(M-1)); %quantization step
quantizerLevels=xmin + (0:M-1)*delta; %output values
if forceZeroLevel==1
    isZeroRepresented = find(quantizerLevels==0); %is 0 there?
    if isempty(isZeroRepresented) %zero is not represented yet
        [ans,closestInd]=min(abs(quantizerLevels));
        closestToZeroValue=quantizerLevels(closestInd);
        quantizerLevels = quantizerLevels - closestToZeroValue;
        xmin = quantizerLevels(1); %update levels
        xmax = quantizerLevels(end);
    end
end
x_i= (x-xmin) / delta; %quantizer levels
x_i = round(x_i); %nearest integer
x_i(x_i<0) = 0; %impose minimum
x_i(x_i>2^b-1) = 2^b-1; %impose maximum
x_q = x_i * delta + xmin;  %quantized and decoded output

if nargout>3
   partitionThresholds = 0.5*(quantizerLevels(1:end-1) + ...
       quantizerLevels(2:end));
end