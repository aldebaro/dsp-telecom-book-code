function [A, Ainverse] = ak_dctmtx(N)
% function [A, Ainverse] = ak_dctmtx(N)
%Calculate the DCT-II matrix of dimension N x N. A and Ainverse are
% the direct and inverse transform matrices, respectively. Ex:
%  [A, Ainv]=ak_dctmtx(4); x=[1:4]'+1j; A*x, dct(x)
Ainverse=zeros(N,N); %pre-allocate space
scalingFactor = sqrt(2/N); %make base functions to have norm = 1
for n=0:N-1 %a loop helps to clarify obtaining inverse matrix
    for k=0:N-1 %first array element is 1, so use A(n+1,k+1):       
       Ainverse(n+1,k+1)=scalingFactor*cos((pi*(2*n+1)*k)/(2*N));
    end
end
Ainverse(1:N,1)=Ainverse(1:N,1)/sqrt(2); %different scaling for k=0
%unitary transform: direct transform is the Hermitian of the inverse
A = transpose(Ainverse); %Matrix is real, so transpose is Hermitian