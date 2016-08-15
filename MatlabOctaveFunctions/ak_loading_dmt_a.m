%DMT using only QAM subchannels. The 2 PAMs are not used.
N = 8; %FFT length
showPlots = 1;
totalPower_dBm = 20.4; %total download power
totalPower = 1e-3 * 10^(totalPower_dBm/10) %convert from dBm to Watts
noisePSD_dBm = -140; %PSD noise level
noisePSD_N0div2 = 1e-3 * 10^(noisePSD_dBm/10) %from dBm to Watts
gap_dB = 6; %gap to capacity (in dB)
gap = 10^(gap_dB/10) %convert from dB to linear
twiceSigma2 = 2 * noisePSD_N0div2; %noise per subchannel
h=fir1(3,0.5)/10^7; %channel
if showPlots == 1
    freqz(h);
    title('Channel frequency response (positive frequencies only)')
    pause
end
Hk = fft(h,N); %use FFT of length N to get channel frequency response
g = abs(Hk).^2

%turn off the PAM subchannels assigning 0 gain to them
g(1)=0;
g(N/2+1)=0;

%now do waterfilling: all subchannels are submitted to the same noise
[txPower,waterlevel,SNR]= ...
    ak_simplewaterfill(g,twiceSigma2,totalPower,gap);

if showPlots == 1
    %plot waterfilling figure in linear scale for all subchannels as PAMs
    A=[gap * (twiceSigma2./g);
        txPower];
    bar(A','stacked')
    xlabel('Tones (k)')
    ylabel('Stacked: inverse SNR (\Gamma\sigma/g) and Tx power')
    hold on
    plot(1:length(txPower),waterlevel*ones(size(txPower)),'-X','markersize',16);
    hold off
    pause
end

%sanity check
if (sum(txPower) - totalPower > 1e-15) 
    error('sum(txPower) differs from totalPower!')
end

%for SNR and bits we are not going to use the negative subchannels
SNR = SNR(1:N/2+1);
SNRdB = 10*log10(SNR)

bitsPerDimension=0.5*log2(1 + SNR/gap);
bits = 2*bitsPerDimension %valid for QAM subchannels

%margin calculation (Eq. 4.7 in page 296 of Cioffi's notes):
disp('Assuming a non-integer bitloading');
lambda = (SNR/gap) ./ (2.^(2*bitsPerDimension) - 1)
lambda_dB = 10*log10(lambda)

disp('Assuming an integer (floored) bitloading');
bits = floor(bits);
bitsPerDimension = bits/2;
lambda = (SNR/gap) ./ (2.^(2*bitsPerDimension) - 1)
lambda_dB = 10*log10(lambda)

%rate
bauds = 4000; 
rate = sum(bits)*bauds