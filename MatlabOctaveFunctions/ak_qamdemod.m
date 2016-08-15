function [symbolIndex, x_hat]=ak_qamdemod(x,M)
% function [symbolIndex, x_hat]=ak_qamdemod(x,M)
%It is restricted to "square" QAM constellations. It does 
%not support "cross" constellations.
%Inputs: x has the QAM values and M the number of symbols
%Outputs: symbolIndex has the indices from 0 to M-1
%         x_hat contains the nearest symbol(s)
b=log2(M); %number of bits
b_i = ceil(b/2); %number of bits for in-phase component
b_q = b-b_i; %remaining bits are for quadrature component
M_i = 2^b_i; %number of symbols for in-phase component
M_q = 2^b_q; %number of symbols for quadrature component
ndx_i=ak_pamdemod(real(x),M_i); %PAM on in-phase
ndx_q=ak_pamdemod(imag(x),M_q); %PAM on quadrature
symbolIndex = ndx_i*M_q + ndx_q; %get QAM index
if nargout > 1 %calculate only if necessary
    const=ak_qamSquareConstellation(M); %QAM const.
    x_hat=const(symbolIndex+1);%add 1 to indices
end
