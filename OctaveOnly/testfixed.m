function [y_cq_iq_pq, y_my, y_matlab]=testfixed
% function [y_cq_iq_pq, y_my, y_matlab]=testfixed
randn('seed',0); %reset seed of randn
N=100; %number of samples
x=randn(1,N); %generate N random samples
y=zeros(size(x)); %pre-allocate space for output
M=4; %filter order
[B,A]=butter(M,0.3); %design IIR filter
is=4; % number of bits for integer part
ds=4; % number of bits for decimal part
xf=fixed(is,ds,x); %create variables with fixed-point
yf=fixed(is,ds,y);
Bf=fixed(is,ds,B);
Af=fixed(is,ds,A);
acc=fixed(2*is,2*ds+1,0); %accumulat. has double precision
zeroReference=acc; %Cannot make acc=0 if acc is FixedPoint
%everything quantized: coeffs, input, internal processing:
y_cq_iq_pq=myFilter(acc,Bf,Af,xf,yf,zeroReference);
%1) no quantization using myFilter:
acc=0; zeroReference=acc;
y_my=myFilter(acc,B,A,x,y,zeroReference);
%2) no quantization using Matlab's filter:
y_matlab=filter(B,A,x);
if nargout == 0
    clf
    n=0:length(y_my)-1;
    plot(n,y_cq_iq_pq.x,n,y_my,n,y_matlab);
    %plot(n,y_my,n,y_matlab);
    legend('Quantized','Not (my)','Not (Matlab)');
end
endfunction
function y = myFilter(acc,b,a,xn,yn,zeroReference)
M=length(b)-1;
N=length(a)-1;
%Note: this code does not treat the transient in first samples. 
%Will assume 0 values. Could assume N >= M
for n=N+1:length(xn) %after transient
    acc = zeroReference; %resets accumulator
    for i=0:M
        acc = acc + b(i+1)*xn(n-i); %implements numerator
    end
    for i=1:N %Note, the code assumes A(1) = 1
        acc = acc - a(i+1)*yn(n-i);%implements denominator
    end
    yn(n) = acc; %update the output
end
y=yn;
endfunction