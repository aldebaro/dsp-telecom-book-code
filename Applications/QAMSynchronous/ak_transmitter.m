function [s,symbols]=ak_transmitter(bitStream)
% function [s,symbols]=ak_transmitter(bitStream)
%From input bit stream (bitStream), create the symbols (symbols)
%sampled at baud rate Rsym and the transmit waveform s, sampled at
%the sampling frequency Fs, where L=Rsym/Fs is the oversampling

global b S L const showPlots htx wc delayInSamples Fs ...
    shouldWriteEPS

%assumes that setGlobalConstants was executed
%slice the bits into the symbol indices:
symbolIndicesTx = ak_sliceBitStream(bitStream, b);
symbols=const(symbolIndicesTx+1); %random symbols
x=zeros(1,S*L); %pre-allocate space
x(1:L:end)=symbols; %complete upsampling operation
%If QAM, yce is the complex envelope:
yce=conv(htx,x); %convolution by shaping pulse
delayInSamples=delayInSamples + round((length(htx)-1)/2);
powerTxComplexEnvelope = mean(abs(yce).^2)
%modulate by carrier at wc rad:
n=0:length(yce)-1; %"time" axis
s=real(yce .* exp(j*wc*n)); %transmitted signal
s=s(:); %use column vector

powerTxSignal = mean(s.^2)

if showPlots || shouldWriteEPS
    clf
    N=5*L;
    start=delayInSamples+5*L;
    t=(start:start+N)/Fs;
    subplot(221)
    plot(t,real(yce(start:start+N)))
    title('Complex envelope (baseband)')
    ylabel('Real (I)')
    axis tight
    subplot(222)
    plot(t,real(s(start:start+N)))
    title('Upconverted (real) Tx signal');
    axis tight
    ylabel('Real')
    subplot(223)
    plot(t,imag(yce(start:start+N)))
    axis tight
    xlabel('time (s)');
    ylabel('Imaginary (Q)')
    subplot(224)
    plot(t,imag(s(start:start+N)))
    axis tight
    xlabel('time (s)');
    ylabel('Imaginary')
    if showPlots == 1
        pause
    end
    if shouldWriteEPS==1
        writeEPS('dt_tx_time','font12Only')
    end
    clf
    subplot(221)
    plot(real(const), imag(const), 'x', 'markersize',16);
    title('Tx Constellation'); grid
    subplot(222)
    pwelch(yce,[],[],[],Fs)
    title('PSD of baseband Tx signal');
    subplot(223)
    pwelch(s,[],[],[],Fs)
    title('PSD of modulated Tx signal');            
    Pyce=pwelch(yce,[],[],[],Fs); %recalculate PSD, store result in Pyce
    f=linspace(-Fs/2,Fs/2,length(Pyce)); %create a frequency axis
    subplot(224); plot(f,fftshift(10*log10(Pyce))); %from -Fs/2 to Fs/2
    grid, title('PSD of baseband Tx signal'); xlabel('Frequency (Hz)')
        
    if showPlots == 1
        pause
    end
    if shouldWriteEPS==1
        writeEPS('dt_tx_frequency','font12Only')
    end
end

