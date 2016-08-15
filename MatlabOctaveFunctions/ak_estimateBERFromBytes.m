function ber = ak_estimateBERFromBytes(bytesTx, bytesRx)
% function ber = ak_estimateBERFromBytes(bytesTx, bytesRx)
%Calculates the percentagem of wrong bits comparing the
%two sequences of bytes.

%get the discrepancies at the bit level
errors = bitxor(uint8(bytesTx), uint8(bytesRx));
N=length(errors); %N is the number of bytes
%a bit error can occur at any position of the byte, need
%to find it and count
numErrors = 0;
for i=1:N
    for j=1:8
        if bitget(errors(i),j)==1
            numErrors = numErrors + 1;
        end
    end
end

ber = numErrors / (8*N); %divide by total number of bits