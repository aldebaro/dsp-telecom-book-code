randn('seed',0); %reset seed of randn
N=100; %number of samples
x=20*randn(1,N); %gerante random samples
M=4; %filter order
[B,A]=butter(M,0.3); %design IIR filter
%Define fixed-point elements
is=3; % number of bits for integer part
ds=5; % number of bits for decimal part
xf=fixed(is,ds,x); %quantize the input
Bf=fixed(is,ds,B); %quantize the filter's numerator
Af=fixed(is,ds,A); %quantize the filter's denominator
y_cn_in=filter(B,A,x); %output with infinite precision
y_cq_in=filter(Bf,Af,x); %output with quantized coefficients but not input
y_cq_iq=filter(Bf,Af,xf); %output with quantized coefficients and input
y_cn_iq=filter(B,A,xf); %output with quantized input only

clf
plot(x);
hold on
plot(xf.x,'r');
legend('Original input','Quantized input');
print -depsc '../../FiguresNonScript/octave_fixed1.eps'

clf
plot(y_cn_in)
hold on
plot(y_cq_in,'r')
%   writeEPS('octave_fixed1')
%plot(y_cn_iq,'r')
legend('Original coefficients','Quantized coefficients');
print -depsc '../../FiguresNonScript/octave_fixed2.eps'