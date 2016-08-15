w=linspace(-pi,pi,1000);
M=8;
x=sin(w*M/2)./sin(w/2);
stem(w,x);

oversample=2;
Fs = 200; %sampling Frequency in Hz
symbolRate = Fs/oversample
p = ones(1,oversample);
%pwelch parameters:
windowSize=256;
numOverlapSamples=windowSize/2;
fftsize=windowSize;

%p = ak_rcosine(1,oversample,'fir/sqrt');
if 0
    waveform = zeros(1,numSymbols*oversample); %pre-allocate space
    waveform(1:oversample:end) = symbols;
    waveform = filter(p,1,waveform); % Pulse shaping filtering
end
%subplot(321);
pulseWaveform = [p zeros(1,windowSize-length(p))];
pwelch(pulseWaveform,windowSize,numOverlapSamples,fftsize,Fs); %estimate PSD

%pwelch(waveform,[],[],[],samplingFrequency); ylabel('');xlabel('');


%%%%%%%%%% NOT FINISHED BELOW %%%%%%%%%%%
if 0
    numberOfBytes=200;
    oversample=8;
    M=4;
    noisePower=2;
    samplingFrequency = 200; %Hz
    symbolRate = samplingFrequency/oversample
    %numberOfBytes -> number of bytes to be transmitted
    %oversample -> oversampling factor
    %M -> modulation order (number of symbols)
    %noisePower -> noise power
    %Outputs:
    %ber -> bit error rate
    %ser -> symbol error rate
    %SNRdB -> signal to noise ratio in dB before matched filtering
    %snrOutMF -> signal to noise ratio in dB after matched filtering
    b=log2(M);
    bytesTx = floor(256*rand(1,numberOfBytes)); %generate random bytes
    symbolIndicesTx = ak_sliceBytes(bytesTx, b);
    %constellation = pammod(0:M-1, M); %if want to see constelllation
    symbols = pammod(symbolIndicesTx,M); % modulate
    %convert symbols into a waveform
    %define a simple shaping pulse
    if 0
        p = ones(1,oversample);
    else
        p=ak_rcosine(1,oversample,'fir/sqrt');
        %p = sin((0:oversample-1)*pi/oversample);%1:oversample;
    end
    %make sure pulse has unitary power
    %p = p / (mean(p.^2));
    numSymbols = length(symbols); %number of symbols
    waveform = zeros(1,numSymbols*oversample); %pre-allocate space
    waveform(1:oversample:end) = symbols;
    waveform = filter(p,1,waveform); % Pulse shaping filtering
    %send waveform through the channel
    n = sqrt(noisePower)*randn(size(waveform));
    r = waveform + n;
    SNRdB=10*log10(mean(waveform.^2)/mean(n.^2));
    disp(['SNR at the input of the matched filter: ' num2str(SNRdB) ' dB'])
    %implement receiver
    rf = filter(p,1,r);
    %normalize
    mean(waveform.^2)
    mean(n.^2)
    Ep = sum(p.^2) %energy of shaping pulse
    rf = rf / Ep;

    %find proper initial sample to start sampling
    initialSample = oversample;
    receivedSymbols = rf(initialSample:oversample:end); %sample

    %split the noise and signal processing for the sake of studying
    nf = filter(p,1,n);
    waveformf = filter(p,1,waveform);
    %sample each one
    noiseInSymbols = nf(initialSample:oversample:end);
    signalInSymbols = waveformf(initialSample:oversample:end);
    snrOutMF=10*log10(mean(signalInSymbols.^2)/mean(noiseInSymbols.^2));
    disp(['SNR at the output of the matched filter: ' num2str(snrOutMF) ' dB'])
    disp(['power of the signal parcel after MF: ' num2str(mean(signalInSymbols.^2))]);
    disp(['power of the noise parcel after MF: ' num2str(mean(noiseInSymbols.^2))]);

    symbolIndicesRx = pamdemod(receivedSymbols, M);
    bytesRx = ak_unsliceBytes(symbolIndicesRx, b);
    ser = ak_calculateSymbolErrorRate(symbolIndicesTx, symbolIndicesRx)
    ber = ak_estimateBERFromBytes(bytesTx, bytesRx)

    subplot(321);
    pwelch(waveform,[],[],[],samplingFrequency); ylabel('');xlabel('');
    title('Transmitter')
    subplot(323);
    pwelch(n,[],[],[],samplingFrequency); xlabel('');title('')
    subplot(325);
    pwelch(r,[],[],[],samplingFrequency); ylabel('');xlabel('Frequency (Hz)');title('')
    subplot(322);
    pwelch(waveformf,[],[],[],samplingFrequency); ylabel('');xlabel('');
    title('Receiver')
    subplot(324);
    pwelch(nf,[],[],[],samplingFrequency); xlabel('');title('')
    subplot(326);
    pwelch(rf,[],[],[],samplingFrequency); ylabel(''); xlabel('Frequency (Hz)');title('')
end