x=[1 2 3 4]; h=[.9 .8]; %signals to be convolved
shouldMakeEquivalent=0 %in general, linear and circular conv. differ
if shouldMakeEquivalent==1
    N=length(x)+length(h)-1; %to force linear and circular coincide
else
    N=max(length(x),length(h)); %required for FFT zero-padding
end
linearConv=conv(x,h) %linear convolution
circularConv=ifft(fft(x,N).*fft(h,N)) %circular convolution, N=4
%circularConv=cconv(x,h,N) %note that Matlab has the cconv function

