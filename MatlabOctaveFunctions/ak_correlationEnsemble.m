function [Rxx,n1,n2]=ak_correlationEnsemble(X, maxTime)
% function [Rxx,n1,n2]=ak_correlationEnsemble(X, maxTime)
%Estimate correlation for non-stationary random processes using
%ensemble averages (does not assume ergodicity).
%Inputs:  - X, matrix representing discrete-time process realizations
%           Each column is a realization of X.
%         - maxTime, maximum time instant starting from n=1, which 
%           corresponds to first row X(1,:). Default: number of rows.
%Outputs: - Rxx is maxTime x maxtime and Rxx[n1,n2]=E[X[n1] X*[n2]]
%         - n1,n2, lags to properly plot the axes. The values of
%           n1,n2 are varied from 1 to maxTime.
[numSamples,numRealizations] = size(X); %get number of rows and col.
if nargin==1
    maxTime = numSamples; %assume maximum possible value
end
Rxx = zeros(maxTime,maxTime); %pre-allocate space
for n1=1:maxTime
    for n2=1:maxTime %calculate ensemble averages
        Rxx(n1,n2)=mean(X(n1,:).*conj(X(n2,:))); %ensemble statistics
        %that depends on numRealizations stored in X
    end
end
n1=1:maxTime; n2=1:maxTime; %create output axes
if nargout < 1 %plot if there are no output arguments
    %Note:
    %x=-3:3; y=-1:1; A=rand(3,7); A(1,5)=20; mesh(x,y,A);
    %xlabel('x'), ylabel('y')
    %When mesh(x,y,A) plots a matrix A, the vector x informs the 
    %values over the columns of A, while y is the values over the 
    %rows. The element A(1,1) has the value of x(1) and y(1). Hence,
    %mesh will show an "image":
    %  A(x(1),y(2))  A(x(2),y(2)) A(x(3),y(2)) ...
    %  A(x(1),y(1))  A(x(2),y(1)) A(x(3),y(1)) ...
    %To show the image as the matrix, maybe needs mesh(x,y,flipud(A))
    mesh(n1,n2,Rxx);
    xlabel('n2');ylabel('n1');zlabel('Rxx[n1,n2]');
end
