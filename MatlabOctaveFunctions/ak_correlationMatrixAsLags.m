function [newRxx,n,lags]=ak_correlationMatrixAsLags(Rxx,n1,n2)
% function [newRxx,n,lags]=ak_correlationMatrixAsLags(Rxx,n1,n2)
%Organize input Rxx[n1,n2] as newRxx[n,lags], where the rows n=n1
%and the columns of newRxx are the lags=n2-n1. For example, 
%newRxx(1,1) is the earliest time instant n=n1(1) with the smallest
%lag value.
%Usage: Rxx=magic(3), [newRxx,n,lags]=ak_correlationMatrixAsLags(Rxx)
%or     ak_correlationMatrixAsLags(Rxx) to plot the result.
%% Check inputs
[M,N]=size(Rxx);
if nargin < 2
    n1=1:M;
    n2=1:N;
else
    if M ~= length(n1)
        error('Length of n1 should match number of rows of Rxx');
    end
    if N ~= length(n2)
        error('Length of n2 should match number of columns of Rxx');
    end
end
%% Find min and max lags to convert n1,n2 into n,lag
n=n1;
minLag=min(n2)-max(n1);
maxLag=max(n2)-min(n1);
lags=minLag:maxLag;
newRxx=zeros(length(n),length(lags));
minLag=min(lags);
%% Copy the values
for i=1:length(n1);
    for j=1:length(n2);
        lag=n2(j)-n1(i);
        columnIndex=1+lag-minLag;
        newRxx(i,columnIndex)=Rxx(i,j);
    end
end
if nargout == 0 %plot if there are no output arguments
    if 1 %use imagesc
        imagesc(n,lags,transpose(newRxx));
        xlabel('absolute time n'), ylabel('lag l');
        axis equal, axis tight, axis xy;
    else %use mesh
        mesh(n,lags,transpose(newRxx)); %transpose of newRxx such ...
        xlabel('absolute time n');ylabel('lag l'); %that n and l ...
        zlabel('Rxx[n,l]'); %are row and column
    end
end
