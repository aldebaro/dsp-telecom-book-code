function chunks = ak_sliceBitStream(bitStream, b)
% function chunks = ak_sliceBitStream(bitStream, b)
%inputs:
%  bitStream -> input bits (0 or 1), e.g. [1 0 0 1 0]
%  b -> number of bits to be used in each output chunk
%output:
%  chunks -> sliced bits, numbers from 0 to (2^b)-1
%See also: ak_sliceBytes and ak_unsliceBytes
bitStream=bitStream(:); %make sure bitStream is a column vector
Nbits=length(bitStream); %get the number of bits
numOfChunks= floor(Nbits/b); %floor discards remaining bits, if they exist
chunks = zeros(1,numOfChunks); %pre-allocate space
for i=0:numOfChunks-1  %convert from 101.. to chunks
    temp = transpose(bitStream(i*b+1:i*b+b)); %extract b bits as row vector    
    %need to find a smarter way to accomplish the conversion:
    temp = num2str(temp); %convert to string to use bin2dec
    temp(find(isspace (temp)))=[]; %eliminate spaces (not required by
    %Matlab, but Octave bin2dec treats spaces as the bit 0)
    chunks(i+1) = bin2dec( temp ); %convert from binary to decimal
end
