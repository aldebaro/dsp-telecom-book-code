function [br, ys]=ak_receiver(r)
% function [br, ys]=ak_receiver(r)
%From received signal r, recover the bitstream br and the received
%symbols ys, where ys is at the baud rate.

global showPlots hhilbert wc M hrx L S delayInSamples ...
    useQAM Fs shouldWriteEPS useIdealChannel phaseCorrection

r=r(:); %make sure it is a column vector
yhilbert = conv(hhilbert,r); %Hilbert transform
yhilbert(1:round((length(hhilbert)-1)/2))=[]; %transient
ya = r + j*yhilbert(1:length(r)); %analytic signal
n=transpose(0:length(ya)-1); %"time" axis

ybb = ya.*exp(-j*wc*n); %downconversion

ybb_filtered = conv(ybb,hrx); %matched filtering
delayInSamples=delayInSamples + round((length(hrx)-1)/2);

firstSample = delayInSamples; %to start getting symbols
ys=ybb_filtered(firstSample:L:end); %sample at baud rate
ys=ys(1:S); %get only the first S symbols

if useIdealChannel~=1
    %to decrease computational cost, compensate the
    %carrier phase after sampling the symbols, not at
    %carrier frequency
    ys=ys * exp(-j*phaseCorrection);
end

if useQAM==1
    symbolIndicesRx=ak_qamdemod(ys,M);
else
    %not sure why, but imaginary part is large (> 0.1)
    ys = real(ys); %discard imaginary part
    symbolIndicesRx=ak_pamdemod(ys,M);
end
%convert from symbol indices to bits
br = ak_unsliceBitStream(symbolIndicesRx, log2(M));

%if user wants to visualize, organize binary codewords along columns
%reshape(br,log2(M),length(br)/log2(M)); %column is a codeword

if showPlots || shouldWriteEPS
    subplot(221)
    pwelch(r,[],[],[],Fs)
    title('PSD at receiver input');
    subplot(222)
    pwelch(ybb,[],[],[],Fs)
    title('PSD after downconversion');
    subplot(223)
    pwelch(ybb_filtered,[],[],[],Fs)
    title('PSD after matched filter');
    subplot(224)
    plot(real(ys), imag(ys), 'x', 'markersize',16);
    title('Received symbols'); grid
    if showPlots == 1
        pause
    end
    if shouldWriteEPS==1
        writeEPS('dt_rx_frequency','font12Only')
    end
end
