h=[1 0.9]; %Impulse response of channel H(z) = 1 + .9 z^-1
N=3; %number of subchannels
H=convmtx(h,N); %matrix to implement convolution
[F,S,Mhermitian] = svd(H); %SVD decomposition
lambdas = diag(S); %lambdas are the singular values
N0d2 = 0.181; %channel noise: bilateral PSD value N0 / 2
gn = lambdas.^2 / N0d2 %get the SNR of each subchannel
