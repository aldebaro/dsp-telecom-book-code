%Script ak_loading_dmt_b.m
%You can use both PAM and QAM subchannels
N = 8;

showPlots = 1;

totalPower_dBm = 20.4;
totalPower = 1e-3 * 10^(totalPower_dBm/10) %convert from dBm to Watts

noisePSD_dBm = -140;
noisePSD_N0div2 = 1e-3 * 10^(noisePSD_dBm/10) %convert from dBm to Watts

gap_dB = 6;
gap = 10^(gap_dB/10) %convert from dB to linear

%noise for one dimension (or subdimension)
sigma2 = noisePSD_N0div2;

h=[2 1 0 3]/10^7.7; %channel
if showPlots == 1
    freqz(h);
    title('Channel frequency response (positive frequencies only)')
    pause
end
Hk = fft(h,N); %use FFT of length N to get channel frequency response
g = abs(Hk).^2

%In DMT, whenever we allocate energy in a complex QAM subchannel, we need to
%allocate the same amount for its respective Hermitian subchannel. We will
%take that in account, assuming N is even.
%take in account that QAM subchannels have dimension equal to 2:
g_secondDimension = g;
g_secondDimension(N/2+1)=[]; %take out Nyquist PAM channel
g_secondDimension(1)=[]; %take out DC PAM channel
g_onlyPAM = [g g_secondDimension];

%now do waterfilling: all PAMs are submitted to the same noise
[txPower,waterlevel,SNR]=ak_simplewaterfill(g_onlyPAM,sigma2,totalPower,gap);

if showPlots == 1
    %plot waterfilling figure in linear scale for all subchannels as PAMs
    A=[gap * (sigma2./g_onlyPAM);
        txPower];
    bar(A','stacked')
    xlabel('Tones (k)')
    ylabel('Stacked: inverse SNR (\Gamma\sigma/g) and Tx power')
    hold on
    plot(1:length(txPower),waterlevel*ones(size(txPower)),'-X','markersize',16);
    hold off
    title('Show all subchannels as PAMs')
    pause
end

%reorganize things, putting together 2 PAMs to create a QAM subchannel
%we know that all active PAM in g has its correspondent PAM in
%g_secondDimension with the same energy, so exclude g_secondDimension and
%multiply by 2 the power of QAM subchannels
powerPerTone = 2*txPower(1:N);
powerPerTone(1) = txPower(1); %keep power of PAM DC subchannel
powerPerTone(N/2+1) = txPower(N/2+1) %keep power of PAM Nyquist subchannel

%sanity check
if (sum(powerPerTone) - totalPower > 1e-15) 
    error('sum(powerPerTone) differs from totalPower!')
end

%reorganize the noise power taking in account PAM and QAM subchannels
noisePower = 2 * sigma2 * ones(size(powerPerTone));
noisePower(1) = sigma2; %keep power of PAM DC subchannel
noisePower(N/2+1) = sigma2; %keep power of PAM Nyquist subchannel

if showPlots == 1
    %plot waterfilling figure in linear scale for all subchannels as PAMs
    A=[gap * (noisePower./g);
        powerPerTone];
    bar(A','stacked')
    xlabel('Tones (k)')
    ylabel('Stacked: inverse SNR (\Gamma\sigma/g) and Tx power')
    title('Show subchannels as PAMs and QAMs')    
    pause
end

%recalculate the receiver SNR
SNR = (powerPerTone.* g) ./ (noisePower)
%for SNR and bits we are not going to use the negative subchannels
SNR = SNR(1:N/2+1);
SNRdB = 10*log10(SNR)

bitsPerDimension=0.5*log2(1 + SNR/gap);
bits = 2*bitsPerDimension; %valid for QAM subchannels
bits(1) = 0.5*log2(1 + SNR(1)/gap); %correct for PAM DC subchannel
bits(N/2+1) = 0.5*log2(1 + SNR(N/2+1)/gap); %correct for PAM Nyquist subchannel
bits

%margin calculation (Eq. 4.7 in page 296 of Cioffi's notes):
lambda = (SNR/gap) ./ (2.^(2*bitsPerDimension) - 1)
lambda_dB = 10*log10(lambda)
