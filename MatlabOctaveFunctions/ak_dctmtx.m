function [A, Ai] = ak_dctmtx(N)
% function [A, Ai] = ak_dctmtx(N)
%Calculate the DCT-II matrix of dimension N x N. 
%A and Ai are the direct and inverse transform matrices, respectively 
Ai=zeros(N,N); %pre-allocate space
scalingFactor = sqrt(2/N); %make base functions to have norm = 1
for n=0:N-1 %a loop helps to clarify obtaining Ai (inverse) matrix
    for k=0:N-1 %first array element is 1, so use A(n+1,k+1):       
       Ai(n+1,k+1)=scalingFactor*cos((pi*(2*n+1)*k)/(2*N));
    end
end
Ai(1:N,1)=Ai(1:N,1)/sqrt(2); %different scaling factor, k=0
%unitary transform, so the direct is the Hermitian:
A = Ai'; %command ' is Hermitian. Matrix is real so, just transpose