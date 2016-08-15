function [yq_my, y_my, y_matlab]=figs_systems_roundoffErrors
% function [yq_my, y_my, y_matlab]=figs_systems_roundoffErrors
randn('seed',0); %reset seed of randn
N=30; %number of samples
x=7*randn(1,N); %generate N random samples
y=zeros(size(x)); %pre-allocate space for output
M=4; %filter order
[B,A]=butter(M,0.3); %design IIR filter
bi=2; % number of bits for integer part
bf=3; % number of bits for fractional part
b=bi+bf+1; %total number of bits, inclusing sign bit
signed=1; %use signed numbers (i.e., not "unsigned")
xf=fi(x,signed,b,bf); %create variables with fixed-point, input
yf=fi(y,signed,b,bf); %filter output
Bq=fi(B,signed,b,bf); %quantized B(z) coefficients
Aq=fi(A,signed,b,bf); %quantized A(z) coefficients
if sum(abs(Bq))==0 || sum(abs(Aq))==0
    error('Quantized filter has B(z) or A(z) only with zero values!')
end
%1) everything quantized: coeffs, input, internal processing:
zeroReference=fi(0,1,2*b,2*bf+1);%using to make acc a fixed-point obj
yq_my=myFilter(Bq,Aq,xf,yf,zeroReference); %all inputs in fixed-point
%2) no quantization, but using myFilter function:
zeroReference=0; %it is a double, so it will be the acc in myFilter
y_my=myFilter(B,A,x,y,zeroReference); %note that x,y,etc are double's
%3) no quantization, but using Matlab's filter:
y_matlab=filter(B,A,x);
if nargout == 0
    clf
    n=0:length(y_my)-1;
    plot(n,yq_my,'LineWidth',3); hold on, 
    plot(n,y_my,'r-o',n,y_matlab,'k-x');
    %plot(n,y_my,n,y_matlab);
    legend('Quantized (myFilter)','Not quant. (myFilter)', ...
        'Not quant. (Matlab`s filter)');
    xlabel('n'), ylabel('Filter outputs y[n]')
    writeEPS('roundoffErrors','font12Only')
end
end
function y = myFilter(Bq,Aq,xn,yn,zeroReference)
M=length(Bq)-1; %get the order of the filter's numerator ...
N=length(Aq)-1; %and denominator
%Note: this code does not treat the transient in first samples and
%will differ from Matlab's filter during the transient.
for n=N+1:length(xn) %after transient
    acc = zeroReference;%resets accumulator,assume fi(0,1,2*b,2*bf+1)
    for i=0:M %implement Direct-II Transposed as Matlab's filter
        acc = acc + Bq(i+1)*xn(n-i); %implements numerator
    end
    for i=1:N %Note, the code assumes A(1) = 1
        acc = acc - Aq(i+1)*yn(n-i);%implements denominator
    end
    yn(n) = acc; %update the output
end
y=yn; %make the output equal to yn (yn is double or fixed point)
end