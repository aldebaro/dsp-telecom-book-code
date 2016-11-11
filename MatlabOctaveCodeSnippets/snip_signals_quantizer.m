Xmin=-1; Xmax=3; %adopted minimum and maximum values
b=2; %number of bits of the quantizer
M=2^b; %number of quantization levels
delta=abs((Xmax-Xmin)/(M-1)); %quantization step
QuantizerLevels=Xmin + (0:M-1)*delta %output values
isZeroRepresented = find(QuantizerLevels==0); %is 0 there?
if isempty(isZeroRepresented) %zero is not represented yet
    Mneg=sum(QuantizerLevels<0); %number of negative
    Xmin = -Mneg*delta; %update the minimum value
    NewQuantizerLevels = Xmin + (0:M-1)*delta %new values
end

