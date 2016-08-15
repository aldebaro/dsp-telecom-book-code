function [symbolIndex, x_hat]=ak_pamdemod2(x,constel)
% function [symbolIndex, x_hat]=ak_pamdemod(x,constel)
%Inputs: x has the PAM values, constel the constellation
%Outputs: symbolIndex has the indices from 0 to M-1, where
%         M is the number of symbols in constel
%         x_hat contains the nearest symbol(s)
symbolIndex=zeros(size(x)); %pre-allocate space
x_hat=zeros(size(x));
myOnes=ones(size(constel)); %vector of M 1's
N=length(x); %number of PAM values in x
for i=1:N %loop over all N input values in x
    temp=x(i)*myOnes; %replicates the value of x(i)
    distances=(temp-constel).^2; %square of Euclidean dist
    index = find(distances==min(distances)); %minima dist.
    %if there are two minima, use the last index to get...
    symbolIndex(i)=index(end)-1; %the same result as round
    x_hat(i)=constel(index(end)); %corresponding symbol
end
