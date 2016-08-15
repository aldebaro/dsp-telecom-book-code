function outputBytes = ak_unsliceBytes(chunks, b)
% function outputBytes = ak_unsliceBytes(chunks, b)
%Reorganize the chunks, which use b bits (per chunk) into bytes.
%b must be 1, 2, 4 or 8 bits.
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
if N~=(length(chunks) / numOfChunksPerByte)
    disp(['Warning: input length is not a multiple of 8 bits!']);
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