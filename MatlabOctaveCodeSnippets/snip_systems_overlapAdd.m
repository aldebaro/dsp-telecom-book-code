x=1:1000; %infinite duration (or "long") input signal
h=ones(1,3); %non-zero samples of finite-length impulse response
Nh=length(h); %number of impulse response non-zero samples
Nb=5; %block (segment) length
Nfft=2^nextpow2(Nh+Nb-1); %choose a power of 2 FFT size
Nx = length(x); %number of input samples
H = fft(h,Nfft); %pre-compute impulse response DFT, with zero-padding
beginIndex = 1; %initialize index for first sample of current block
y = zeros(1,Nh+Nx-1); %pre-allocate space for convolution output
while beginIndex <= Nx %loop over all blocks
    endSample = min(beginIndex+Nb-1,Nx);%last sample of current block
    Xblock = fft(x(beginIndex:endSample),Nfft); %DFT of block
    yblock = ifft(Xblock.*H,Nfft); %get circular convolution result
    outputIndex  = min(beginIndex+Nfft-1,Nh+Nx-1); %auxiliary variab.
    y(beginIndex:outputIndex) = y(beginIndex:outputIndex) + ...
        yblock(1:outputIndex-beginIndex+1); %add parcial result
    beginIndex = beginIndex+Nb; %shift begin of block
end
stem(y-conv(x,h)) %compare the error with result from conv