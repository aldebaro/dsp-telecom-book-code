%Script ak_error_prob.m
power = [0.0150 0.0115 0.0105 0.0253 0] %Watts
%bits = [1.3378 0.5663 0.5057 1.8027 0]
bits=[1 1 1 2 0]

noisePSD_dBm = -140;
noisePSD_N0div2 = 1e-3 * 10^(noisePSD_dBm/10) %convert from dBm to Watts
%noise for one dimension (or subdimension)
sigma2 = noisePSD_N0div2;

h=[2 1 0 3]/10^7.7; %channel
Hk = fft(h,N); %use FFT of length N to get channel frequency response
g = abs(Hk).^2

%the first 3 channels will be PAM and the fourth a QAM
%calculate the probability of subsymbol error (per subchannel)
%for PAM
M = 2.^bits;
M(end)=0;

%SNR at the transmitter
SNR = power / sigma2;
SNR(4) = power(4) / (2*sigma2); %correct for the QAM subchannel
%estimate symbol error probability
PePAMs = 2*(1-1./M(1:3)).*qfunc(sqrt( (3./(M(1:3).^2 - 1)) .* SNR(1:3)))
PeQAMs = 4*(1-1./sqrt(M(4))).*qfunc(sqrt( (3./(M(4) - 1)) .* SNR(4)))


%SNR at the receiver
SNR = (power .* g(1:5)) / sigma2;
SNR(4) = power(4) .* g(4)/ (2*sigma2); %correct for the QAM subchannel
%estimate symbol error probability
PePAMs = 2*(1-1./M(1:3)).*qfunc(sqrt( (3./(M(1:3).^2 - 1)) .* SNR(1:3)))
PeQAMs = 4*(1-1./sqrt(M(4))).*qfunc(sqrt( (3./(M(4) - 1)) .* SNR(4)))
