function r=dt_channel(x)

global useQAM delayInSamples showPlots Fs shouldWriteEPS

if ~isreal(x)
    error(['This is a passband, not an equivalent '...
        'baseband simulation. Channel input must be real!']);
end

%perform clipping and count the number of clippings:
maxAmplitude = 10;
minAmplitude = -10;
saturationIndices = x>maxAmplitude;
numOfSaturations = sum(saturationIndices);
if numOfSaturations > 0
    warning(['Positive clips=' num2str(numOfSaturations)])
end
x(saturationIndices) = maxAmplitude;
saturationIndices = x<minAmplitude;
numOfSaturations = sum(saturationIndices);
if numOfSaturations > 0
    warning(['Negative clips=' num2str(numOfSaturations)])
end
x(saturationIndices) = minAmplitude;

%filter
[B,A]=dt_getChannelTransferFunction();
%this channel has a passband from 0.3pi to 0.7pi, which
%corresponds to 0.3(Fs/2) to 0.7(Fs/2). For Fs=10000 Hz,
%this gives a band from 1500 to 3500, BW=2 kHz

%do not want to use filter, but conv:
h=impz(B,A,400); %approximate h[n] with 400 samples
z=conv(x,h); %note that z is longer than x
powerRxSignal = mean(abs(z).^2)

%Observing the plot, it was noticed that, at the band
%of interest, the group delay is approximately 7 samples
delayInSamples = delayInSamples + 7;

%add AWGN with desired power
SNRdB = 10; %desired signal to noise ratio in dB
SNR=10^(0.1*SNRdB); %SNR in linear scale
noisePower = powerRxSignal/SNR %noise power

%The code below is not necessary because it is not an
%equivalent complex baseband simulation:
%if useQAM == 1
%    %generate complex noise, note that it is noisePower/2
%    noise = sqrt(noisePower/2)*(randn(size(z))+...
%        j*randn(size(z)));
%else
%    noise = sqrt(noisePower)*randn(size(z));
%end

noise = sqrt(noisePower)*randn(size(z));
r = z + noise; %add noise
%estimate SNR
SNRactual=10*log10(mean(abs(z).^2)/mean(abs(noise).^2))

if showPlots || shouldWriteEPS
    clf
    subplot(221)
    [H,f]=freqz(B,A,[],Fs); %show frequency response
    plot(f,10*log10(abs(H)));
    axis tight
    title('Channel frequency response');
    ylabel('|H(f)| (dB)')
    subplot(222)
    %writeEPS('dt_channel_group_delay','font12Only')
    zplane(B,A) %show the filter is not minimum-phase
    title('Channel poles and zeros');
    subplot(223)
    [g,f]=grpdelay(B,A,512,Fs); %group delay
    plot(f,g);
    xlabel('f (Hz)'); ylabel('Group delay (samples)');
    title('Channel group delay');
    axis tight
    subplot(224)
    pwelch(noise,[],[],[],Fs);
    title('Noise (AWGN) PSD');
    if showPlots == 1
        pause
    end
    if shouldWriteEPS==1
        writeEPS('dt_channel','font12Only')
    end
end
