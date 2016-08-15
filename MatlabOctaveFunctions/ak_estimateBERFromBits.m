function ber = ak_estimateBERFromBits(bitsTx, bitsRx)
% function ber = ak_estimateBERFromBits(bitsTx, bitsRx)
%Calculates the percentagem of wrong bits comparing the
%two sequences of bits (elements are 0 or 1).

%get the discrepancies at the bit level
%errors = bitxor(bitsTx, bitsRx);
%converts to logical just to make sure, because e.g., if one
%vector is char and another logical, the comparison fails
errors = logical(bitsTx) ~= logical(bitsRx);
N=length(errors); %N is the number of bits
numErrors = sum(errors);
ber = numErrors / N; %divide by total number of bits