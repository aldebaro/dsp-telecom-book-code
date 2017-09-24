function outputBytes = ak_unsliceBytes(chunks, b)
% function outputBytes = ak_unsliceBytes(chunks, b)
%Reorganize (concatenate) chunks into bytes. The "chunks" are
%integer numbers from 0 to 2^(b-1) that can be represented by b bits,
%and can correspond can to the symbols of a constellation with 2^b
%symbols. (per chunk) 
%In this implementation, b must be 1, 2, 4 or 8 bits.
%
%Example assuming chunks from constellation with b=2 bits/symbol
%chunks=[0, 0, 2, 1, 3, 3, 3, 3]; %correspond to 16 bits: 2 bytes
%bytes=ak_unsliceBytes(chunks, 2) %result are bytes=[9   255]
%chunksAgain=ak_sliceBytes(bytes, 2) %get the chunks back
%Note the first byte (9) corresponds to the combination of chunks
%[0, 0, 2, 1] and the second (255) of [3, 3, 3, 3].
%
%See also: ak_sliceBytes and ak_sliceBitStream
if rem(8,b)~=0
    disp('this is a very simple unslicer');
    disp('try writing a more general code. This one is limited:');
    error('b must be 1, 2, 4 or 8 bits per symbol');    
end
numOfChunksPerByte = 8/b; %stores how many chuncks are in one byte
if numOfChunksPerByte == 1 %nothing to be done but a cast
    outputBytes = double(chunks);
    return;
end
chunks = double(chunks); %avoid problems if chunks is uint8,int8,etc.
N = floor(length(chunks) / numOfChunksPerByte);
if N~=(length(chunks) / numOfChunksPerByte) %discards if needed
    disp(['Warning: input length is not a multiple of 8 bits!']);
    numOfDiscarded=length(chunks)-N*numOfChunksPerByte;
    disp(['The last ' num2str(numOfDiscarded) ...
        ' chunks were discarded.']);
end        
outputBytes = zeros(1,N); %pre-allocate space
chunkCount = 1; %count chunks
for i=1:N
    temp = chunks(chunkCount);
    chunkCount = chunkCount + 1;
    for j=2:numOfChunksPerByte
        temp = bitshift(temp,b);
        temp = temp + chunks(chunkCount);
        chunkCount = chunkCount + 1;
    end
    outputBytes(i) = temp;
end