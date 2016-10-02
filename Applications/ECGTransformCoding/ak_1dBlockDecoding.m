function x=ak_1dBlockDecoding(X,A,K)
% function x=ak_1dBlockDecoding(X,A,K)
%Perform the inverse transform of data X assuming it contais only
%the first K coefficients of each block. Matrix A has dimension
%M x M. Input vector X has N blocks of dimension K each.
%Add M-K zeros to each block before the inversion (zero-padding).
%The output x is a vector of dimension N*M.

[M,temp] = size(A); %get the transform dimension M

if M~=temp %check if matrix is square
    error('Matrix must be square!');
end

if K>M %check (cannot have K>M)
    error(['K=' num2str(K) ' cannot be larger than matrix '...
        'dimension M=' num2str(M)]);
end

if ~isvector(X) %check if x is a vector
    error('Input vector must be a one dimensional array!');
end

%assume that encoding stage kept only the first K coefficients of the
%M-point transform. Now recover M samples from these K coefficients
N=floor(length(X)/K); %number of blocks of K samples
%Xall has all coefficients (uses zero-padding)
Xall=zeros(N*M,1); %allocate space for N blocks with M elements each
for i=1:N
    %endpoints of input vector with K coefficients
    startSample = (i-1)*K+1;
    endSample = (i-1)*K+K;
    block = X(startSample:endSample);
    %endpoints of output vector with truncated coefficients
    startSample = (i-1)*M+1;
    endSample = (i-1)*M+K;
    Xall(startSample:endSample)=block; %copy the K coefficients
    %obs: note that the other coefficients remain zero
end

x = ak_1dBlockTransform(Xall,A); %calculate the inverse M-point transform
