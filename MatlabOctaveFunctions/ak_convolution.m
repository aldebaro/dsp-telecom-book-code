function y=ak_convolution(x,h)
% function y=ak_convolution(x,h)
%convolution between sequences x and h
N1=length(x); %get the number of samples in x
N2=length(h);
N=N1+N2-1; %this is the number of samples in the output y
y=zeros(1,N); %pre-allocate space for y[n]
for i=1:N1 %calculate y[n]= sum_k x[k] h[n-k]
    y(i:i+N2-1)=y(i:i+N2-1)+x(i)*h; %scaling h by x(i)
end