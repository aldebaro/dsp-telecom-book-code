x=transpose(1:1000); %(eventually long) input signal,as column vector
h=ones(3,1); %non-zero samples of finite-length impulse response
Nh=length(h); %number of impulse response non-zero samples
Nb=5; %block (segment) length
Nbout = Nb+Nh-1; %number of samples at the output of each block
Nx = length(x); %number of input samples
hmatrix = convmtx(h,Nb); %impulse resp. in matrix notation
beginNdx = 1; %initialize index for first sample of current block
y = zeros(Nh+Nx-1,1); %pre-allocate space for convolution output
for beginNdx=1:Nb:Nx %loop over all blocks
    endIndex = beginNdx+Nb-1; %current block end index
    xblock=x(beginNdx:endIndex); %block samples, as column vector
    yblock = hmatrix * xblock; %perform convolution for this block    
    y(beginNdx:beginNdx+Nbout-1) = y(beginNdx:beginNdx+Nbout-1) + ...
        yblock; %add parcial result
end
plot(y-conv(x,h)) %compare the error with result from conv