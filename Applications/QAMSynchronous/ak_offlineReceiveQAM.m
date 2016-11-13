dt_setGlobalConstants %set global variables
global txBitStream tailLength;

showPlots=1;%in case want to overwrite value in dt_setGlobalConstants
shouldWriteEPS=1; %write output EPS files (with print -depsc)

[r,Fs2]=wavread('c:\temp\output.wav'); %file with recorded QAM / PAM
if Fs2 ~= Fs
    error('Discrepant sampling frequency!') %just to check
end

%% Get the baseband complex envelope
r=r(:); %r is received signal. Make sure it is a column vector
yhilbert = conv(hhilbert,r); %Hilbert transform
yhilbert(1:round((length(hhilbert)-1)/2))=[]; %take out transient
ya = r + j*yhilbert(1:length(r)); %analytic signal
n=transpose(0:length(ya)-1); %generate the "time" axis
ybb = ya.*exp(-j*wc*n); %frequency downconversion (to baseband)
ybb_filtered = conv(ybb,hrx); %matched filtering

%% Symbol timing synchronization: find where preamble starts
maxAbsR=-1; %maximum crosscorrelation, initialize with negative value
%define a range of samples to search (assume a valid frame is not far
%from the beginning of the file. You may increase the number below:
windowSearchLength=2*L*(preambleLength + S + tailLength);
ws=ybb_filtered(1:windowSearchLength); %extract segment to work with
for d=1:L %hypothesize the best sampling instant (symbol timing)
    temp=ws(d:L:end); %downsampling from Fs to baud rate
    [R,lags]=xcorr(temp,preamble); %cross-correlation with preamble
    maxR=max(abs(R)); %find maximum
    if (maxR > maxAbsR) %update if best option
        dbest = d;
        maxlag = lags(find(abs(R)==maxR,1)); %choose first maximum
        maxAbsR = maxR;
    end
end
if showPlots==1 || shouldWriteEPS==1
    clf
    subplot(221)
    plot(0:length(r)-1,r);
    xlabel('n (samples)'), ylabel('x[n]')
    title('Received QAM signal');
    axis tight
    subplot(223)
    temp=ybb_filtered(dbest:L:end);%downsampling from Fs to baud rate
    [R,lags]=xcorr(temp,preamble); %cross-correlation with preamble
    plot(lags,real(R)) %plot real part of crosscorrelation
    title('Crosscorrelation: x[n] and preamble');
    xlabel('lag m'), ylabel('Real part of Rxy(m)'), grid
end

ys=ybb_filtered(dbest+maxlag*L:L:end); %sample at baud rate
recoveredPreamble=ys(1:preambleLength); %get the preamble
recoveredSymbols=ys(preambleLength+1:preambleLength+S); %and symbols

%% Compensate gain and phase incorporated by the channel
%correct the gain and phase using the preamble information:
gainPhaseAdjustment=mean(recoveredPreamble./preamble);
%phaseCorrection=mean(angle(recoveredPreamble)-angle(preamble))
%temp=recoveredPreamble*exp(-j*phaseCorrection); %only phase, no gain
%phaseCorrection=angle(gainPhaseAdjustment); %alternative
if showPlots==1 || shouldWriteEPS==1
    subplot(222)
    plot(real(recoveredSymbols), imag(recoveredSymbols), 'x', 'markersize',16);
    title('Received symbols before equalization'); grid
end
recoveredSymbols=recoveredSymbols/gainPhaseAdjustment;

%% Decisions (find nearest constellation symbol) and bit conversion
if useQAM==1
    symbolIndicesRx=ak_qamdemod(recoveredSymbols,M);
else %not sure why, but imaginary part is large (> 0.1)
    recoveredSymbols = real(recoveredSymbols); %discard imaginary part
    symbolIndicesRx=ak_pamdemod(recoveredSymbols,M);
end
%convert from symbol indices to bits
rxBitStream = ak_unsliceBitStream(symbolIndicesRx, log2(M));
%estimate BER (both vectors must have the same length)
BER=ak_estimateBERFromBits(txBitStream, rxBitStream)

baud = Fs/L  %symbol rate (bauds)
gross_rate_bps = baud*b  %total rate (bits per second), information and overhead
net_rate_bps = gross_rate_bps * (S/(S+preambleLength+tailLength)) %only information bits

if showPlots==1 || shouldWriteEPS==1
    subplot(224)
    plot(real(recoveredSymbols), imag(recoveredSymbols), 'x', 'markersize',16);
    title('Equalized received symbols'); grid
    %To make a figura taller and wider
    x=get(gcf, 'Position'); %get figure's position on screen
    x(4)=floor(x(4)*1.4); %adjust the size making it "taller"
    x(3)=floor(x(3)*1.4); %adjust the size making it "wider"
    set(gcf, 'Position',x);
    if shouldWriteEPS == 1
        %instead of the one below, I will use a pre-generated figure
        writeEPS('qamOverSoundBoard_notused','font12Only')
    end
end
