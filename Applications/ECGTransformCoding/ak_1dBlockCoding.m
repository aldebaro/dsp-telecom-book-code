function Xt=ak_1dBlockCoding(x,A,K)
% function Xt=ak_1dBlockCoding(x,A,K)
%Transform the input data x using matrix A and keep only the
%first K coefficients of each block. Matrix A has dimension
%M x M. Vector x has N blocks of dimension M each.
%The output Xt is a vector of dimension N*K.

[M,temp] = size(A); %get the transform dimension M

if M~=temp %check if matrix is square
    error('Matrix must be square!');
end

if ~isvector(x) %check if x is a vector
    error('Input vector must be a one dimensional array!');
end

X = ak_1dBlockTransform(x,A); %calculate transform
%keep only the first K coefficients of the M-point transform
N=floor(length(X)/M); %number of blocks of M samples
Xt=zeros(N*K,1); %allocate space for N blocks with K elements each
for i=1:N
    %endpoints of input vector with all coefficients
    startSample = (i-1)*M+1;
    endSample = (i-1)*M+M;
    block = X(startSample:endSample);
    %endpoints of output vector with truncated coefficients
    startSample = (i-1)*K+1;
    endSample = (i-1)*K+K;
    Xt(startSample:endSample)=block(1:K);
end