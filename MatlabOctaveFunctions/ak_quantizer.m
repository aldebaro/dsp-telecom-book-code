function [x_q,x_i]=ak_quantizer(x,delta,b)
% function [x_q,x_i]=ak_quantizer(x,delta,b)
%This function assumes the quantizer allocates 2^(b-1) levels to
%negative output values, one level to the "zero" and 2^(b-1)-1 to 
%positive values. See ak_quantizer2.m for more flexible allocation.
%The output x_i will have negative and positive numbers, which 
%correspond to encoding the quantizer's output with two's complement.
x_i = x / delta; %quantizer levels
x_i = round(x_i); %nearest integer
x_i(x_i > 2^(b-1) - 1) = 2^(b-1) - 1; %impose maximum 
x_i(x_i < -2^(b-1)) = -2^(b-1); %impose minimum
x_q = x_i * delta;  %quantized and decoded output
