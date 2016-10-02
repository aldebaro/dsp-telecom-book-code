function X = ak_1dBlockTransform(x,A)
% function X = ak_1dBlockTransform(x,A)
%Segment (block) x and calculates the transform specified by
%a squarematrix A of dimension M x M. Each block (frame) of x has M
%samples.
%Example using the DCT transform:
%A=dctmtx(4);
%x=[1 2 3 4 1 2 3 4]'; %two blocks of M=4 samples eah
%X=ak_1dBlockTransform(x,A);
%Ainverse = A'; %inverse is the Hermitian because the DCT matrix is unitary
%x2=ak_1dBlockTransform(X,Ainverse);
%numericalError = x-x2;
%
%obs: should give for the two blocks of 4-samples the same result as the
%DCT using:
%z=[1 2 3 4];
%Z=dct(z);
%z2=idct(Z);
[M,temp] = size(A); %get the transform dimension M
if M~=temp %check if matrix is square
    error('Matrix must be square!');
end
if ~isvector(x) %check if x is a vector
    error('Input vector must be a one dimensional array!');
end
%make sure x is a column vector to allow multiplying by A below
x=x(:); %forces x to be a column vector
N=floor(length(x)/M); %number of blocks of M samples each
X=zeros(size(x)); %pre-allocate space
for i=1:N %loop over all N blocks
    startSample = (i-1)*M+1; %block starting sample
    endSample = (i-1)*M+M; %block ending sample
    block = x(startSample:endSample); %extract M samples
    X(startSample:endSample)=A*block; %calculate the transform
end
