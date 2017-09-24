function chunks = ak_sliceBytes(inputBytes, b)
% function chunks = ak_sliceBytes(inputBytes, b)
%inputs:
%  inputBytes -> input bytes, numbers from 0 to 255
%  b -> number of bits to be extracted of each byte. The
%       value of b must be 1, 2, 4 or 8.
%output:
%  chunks -> sliced bytes, numbers from 0 to (2^b)-1 that may 
%            represent the 2^b symbols of a digital modulator
%Example:
% ak_sliceBytes([255 16], 4) %slice ("cut") in chunks of b=4 bits
% ans = 15    15     1     0 %output
%See also: ak_unsliceBytes and ak_sliceBitStream

if rem(8,b)~=0
    disp('this is a very simple slicer');
    disp('try writing a more general code. This one is limited:');
    disp('the input data must be bytes (numbers from 0 to 255) and');
    error('b must be b=1, 2, 4 or 8 bits per symbol');    
end

%check input dynamic range:
if min(inputBytes) < 0
    error('input bytes cannot be less than 0');
end
if max(inputBytes) > 255
    error('input bytes cannot be greater than 255');
end

numOfChunksPerByte = 8/b; %stores how many chuncks are in one byte
if numOfChunksPerByte == 1 %nothing to be done
    chunks = inputBytes;
    return;
end
N=length(inputBytes);
chunks = zeros(1,N*numOfChunksPerByte); %pre-allocate space
chunkCount = 1; %count chunks
for i=1:N %for all bytes
    thisByte = inputBytes(i);
    rangeOfBits = 8:-1:8-b+1; %reset the range
    for j=0:numOfChunksPerByte-1
        tempArray = bitget(uint8(thisByte),rangeOfBits);        
        tempArray = num2str(tempArray);
        %following is not required by Matlab, but Octave bin2dec
        %treats spaces as the bit 0
        tempArray(find(isspace(tempArray)))=[]; %eliminate spaces 
        chunks(chunkCount) = bin2dec(tempArray);
        rangeOfBits = rangeOfBits - b; %update the range
        chunkCount = chunkCount + 1;
    end
end