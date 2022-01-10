function [x_q,x_i,quantizerLevels,partitionThresholds] = ...
    ak_quantizer2(x,b,xmin,xmax,forceZeroLevel)
%function [x_q,x_i,quantizerLevels]=ak_quantizer2(x,b,xmin,xmax,...
%    forceZeroLevel)
%Design a uniform quantizer with the option to create a level to
%represent "zero".
%Note that x_i has values from 0 to (2^b)-1.
if nargin < 3 %use default values
    xmin=min(x);
    xmax=max(x);
    forceZeroLevel=0;
end
M=2^b; %number of quantization levels

%Choose the min value such that the result coincides with Lloyd's
%optimum quantizer when the input is uniformly distributed. Instead of
%delta=abs((xmax-xmin)/(M-1)); %as quantization step use:
delta=abs((xmax-xmin)/M); %quantization step
quantizerLevels=xmin+(delta/2) + (0:M-1)*delta; %output values
if forceZeroLevel==1
    isZeroRepresented = find(quantizerLevels==0); %is 0 there?
    if isempty(isZeroRepresented) %zero is not represented yet
        min_abs=min(abs(quantizerLevels));
        %take in account that two levels, say -5 and 5 can be minimum
        minLevelIndices=find( abs(quantizerLevels) == min_abs );
        %make sure it is the largest, such that there are more negative
        %quantizer levels than positive
        closestInd=minLevelIndices(end); 
        closestToZeroValue=quantizerLevels(closestInd);
        quantizerLevels = quantizerLevels - closestToZeroValue;
        %xmin = quantizerLevels(1); %update levels
        %xmax = quantizerLevels(end);
    end
end

xminq=min(quantizerLevels);
xmaxq=max(quantizerLevels);
x_i= (x-xminq) / delta; %quantizer levels
x_i = round(x_i); %nearest integer
x_i(x_i<0) = 0; %impose minimum
x_i(x_i>2^b-1) = 2^b-1; %impose maximum
x_q = x_i * delta + xminq;  %quantized and decoded output

if nargout>3
   partitionThresholds = 0.5*(quantizerLevels(1:end-1) + ...
       quantizerLevels(2:end));
end