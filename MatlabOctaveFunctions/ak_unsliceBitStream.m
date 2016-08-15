function bitStream = ak_unsliceBitStream(chunks, b)
% function bitStream = ak_unsliceBitStream(chunks, b)
%inputs:
%  chunks -> sliced bits, numbers from 0 to (2^b)-1
%  b -> number of bits to be used in each output chunk
%output:
%  bitStream -> input bits (0 or 1) as a column vector
bits=dec2bin(chunks,b); %convert to bits
%prepare to concatenate along columns via command bits(:)
bits=transpose(bits); 
bitStream=bits(:); %generate one column vector
if length(bitStream) ~= b*length(chunks)
    error('Input chunks have numbers outside range [0,2^b-1]')
end
%at this point, bitStream is "char" (a string) and should be converted
%to a number or to type "logical"
bitStream = str2num(bitStream); %convert to double
bitStream = logical(bitStream); %convert to logical