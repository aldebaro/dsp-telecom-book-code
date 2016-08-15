function [y,n]=ak_convolution2(x1,x2,n1,n2)
% function [y,n]=ak_convolution2(x1,x2,n1,n2)
%calculate the convolution between the sequences x1 and x2
%that start at index n1 and n2, respectively
%Example: [y,n]=ak_convolution2(1:3,5:8,-3,2); stem(n,y)
N1=length(x1); %get the number of samples in x1
N2=length(x2); %get the number of samples in x2
N=N1+N2-1; %this is the number of samples in the output y
y=zeros(1,N); %pre-allocate space for y[n]
for i=0:N1-1 %calculate y[n] = sum_k x1[k] x2[n-k]
    for j=0:N2-1
        y(i+j+1) = y(i+j+1) + x1(i+1)*x2(j+1); %update
    end
end
n=n1+n2:n1+n2+N-1; %generate the "time" indices