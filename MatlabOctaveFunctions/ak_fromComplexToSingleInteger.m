function [out,delta,minimumIndex,peakValue]=ak_fromComplexToSingleInteger(X,M)
% function [out,delta,minimumIndex,peakValue]=ak_fromComplexToSingleInteger(X,M)
%quantize convert numbers and represent each one as an integer,
%which can be decoded back as the complex number, with a quantization
%error. Assumes the dynamic range from real and imaginary parts of X
%are the same.
%Inputs: X - column vector with complex numbers
%        M - number of bins per dimension (real and imaginary)
%Outputs: out - integer numbers representing X. The number of possible
%       values of out range from 0 to (M^2-1) and X=0 is mapped to out=M+1.
%       For example, a histogram of M^2-1 bins is enough to capture all
%       their distinct values.
%       The other outputs are useful to reconstruct approximations of X.
%       Look at the source code for their meaning.
%Example:
%X=[-4-4j; -4; -4+4j; -4j; 0; 4j; 4-4j; 4; 4+4j; 0; 0; 3+2j; 0.4-2.8j]
%M=3; %number of bins (quantization levels) per dimension
%[singleNumerRepresentation,delta,minimumIndex,peakValue]=ak_fromComplexToSingleInteger(X,M)
%to recover the numbers:
%rr = floor(singleNumerRepresentation / M)
%ri = rem (singleNumerRepresentation, M)
%Xrr = delta * (rr-minimumIndex + j*(ri-minimumIndex))
%disp ('quantization error')
%X-Xrr

if nargin==1
    M=11; %default value
end
if rem(M,2)==0
    error('The number of bins per dimension (real or imag) must be an odd number')
end

if isreal(X)
    error('The data is real, not complex. Use hist instead of this function')
end
Xr = real(X);
Xi = imag(X);

peakValue = max(max(abs(Xr)),max(abs(Xi)));
delta = 2*peakValue / (M-1);

minimumIndex = (M-1)/2; %note that M is an odd number

%make them positive numbers
Xr_indices = round(Xr / delta) + minimumIndex;
Xi_indices = round(Xi / delta) + minimumIndex;

out = M*Xr_indices + Xi_indices;

