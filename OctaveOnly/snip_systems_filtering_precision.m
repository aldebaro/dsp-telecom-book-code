N=100; %number of samples
x=20*randn(1,N); %gerante random samples
M=4; %filter order
[B,A]=butter(M,0.3); %design IIR filter
%Define fixed-point elements:
bi=3; % number of bits for integer part
bf=5; % number of bits for fractional part
xf=fixed(bi,bf,x); %quantize the input
Bf=fixed(bi,bf,B); %quantize the filter's numerator
Af=fixed(bi,bf,A); %quantize the filter's denominator
y1=filter(B,A,x); %output with ("infinite") double precision
y2=filter(Bf,Af,x); %quantized: only filter coefficients
y3=filter(Bf,Af,xf);%quantized: input and coeffficients
y4=filter(B,A,xf); %quantized: only input
y5=fixed(bi,bf,y1); %quantized: input, output and coefficients