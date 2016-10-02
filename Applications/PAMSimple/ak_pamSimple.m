%PAM example: transmission using frequency upconversion
%%%%%%%%% Parameters to be changed / tuned %%%%%%%%%
M = 8; %number of constell. symbols, b=log2(M) bits/symbol
Fs = 20000; %sampling frequency, Hz
L = 80; %oversampling factor. Assumed to be an even number
S = 100; %number of symbols to be transmitted
channelNumber = 1; %choose the channel, from 0 to 3 (2 is hardest)
showPlots = 1; %if 1, some plots are shown
Nequ = 40; %order of equalizer filter
verify_ISI_atTx = 1; %verify or not ISI at transmitter
useCorrelationForSync=1; %use crosscorrelation for synchronism?
%%%%%%%%% Fixed parameters, no need to change %%%%%%%%%
Fc1 = 3000; %passband channel, lower passband frequency
Fc2 = 3800; %passband channel, uppper passband frequency
BW = Fc2 - Fc1; %approximate channel bandwidth
Fc = (Fc1 + BW/2); %carrier frequency (Hz)
wc = 2*pi*Fc / Fs; %convert from W in rad/s to w in rad
%make all channels minimum phase to simplify equalization
ak_getChannel; %invoke script to get the channel
B_channel = ak_forceStableMinimumPhase(B_channel,0.1);
h=impz(B_channel,A_channel,400); %h[n] with 400 samples
h_equalizer=impz(A_channel,B_channel,Nequ+1); %equalizer
p = transpose(fir1(L,(BW/20)/Fs)); %shaping pulse (FIR filter) design
%make sure the sample corresponding to cursor is 1
cursorIndex=round((length(p)+1)/2); %assumes length(p) is odd
delayInSamples = cursorIndex; %filter delay equals cursor
scalingFactor = 1/p(cursorIndex); %find scaling factor...
p = p * scalingFactor; %to make p(cursorIndex) = 1
%generate baseband PAM symbols and transmitted signal
constellat=-(M-1):2:M-1; %PAM constellation
ind=floor(M*rand(S,1)); %random indices from 0 to M-1
pamSymbols=transpose(constellat(ind+1)); %sequence of random symbols
x=zeros(S*L,1); %pre-allocate space
x(1:L:end)=pamSymbols; %complete upsampling operation
xp=conv(x,p); %PAM baseband signal
if verify_ISI_atTx == 1 %check ISI at the transmitter
    zz=xp(delayInSamples:L:end);
    disp(['Power of ISI at Tx (should be zero) = ' ...
        num2str(mean((zz(1:S)-pamSymbols).^2)) ' Watts'])
end
%Frequency upconversion: modulate baseband PAM to wc
filterOrder=transpose(0:length(xp)-1); %"time" axis, as column vector
carrier = cos(wc*filterOrder); %generate carrier at transmitter
s = xp .* carrier; %transmitted signal
%Process signal through the channel
z=conv(s,h); %note that z is longer than s
%estimate the channel delay within the passband:
%[groupDelay,f]=grpdelay(h,1,linspace(Fc1,Fc2,50),Fs)%wrong in Octave
%[groupDelay,w]=grpdelay(h,1,(2*pi/Fs)*linspace(Fc1,Fc2,50),2*pi);
[groupDelay,w]=grpdelay(h,1,500);
wminNdx=find(w >= (2*pi*Fc1)/Fs,1,'first'); %indices for passband
wmaxNdx=find(w <= (2*pi*Fc2)/Fs,1,'last');
channelDelayInSamples=round(mean(groupDelay(wminNdx:wmaxNdx))); %mean
delayInSamples=delayInSamples+channelDelayInSamples;
%generate AWGN with desired power
SNRdB = 50; %desired signal to noise ratio in dB
SNR=10^(0.1*SNRdB); %SNR in linear scale
powerRxSignal = mean(abs(z).^2); %signal power at receiver
noisePower = powerRxSignal/SNR %noise power
r = z + sqrt(noisePower)*randn(size(z)); %add noise
r = conv(r,h_equalizer);%equalization (one can eventually disable it)
%command below did not work on Octave:
[groupDelay,f]=grpdelay(h_equalizer,1,linspace(Fc1,Fc2,50),Fs);
[groupDelay,w]=grpdelay(h_equalizer,1,500); %first, get for all range
wminNdx=find(w >= (2*pi*Fc1)/Fs,1,'first'); %indices for passband
wmaxNdx=find(w <= (2*pi*Fc2)/Fs,1,'last'); %now only for passband:
equalizerDelayInSamples=round(mean(groupDelay(wminNdx:wmaxNdx)))
delayInSamples = delayInSamples + equalizerDelayInSamples;
%regenerate carrier at the receiver
filterOrder=transpose(0:length(r)-1); %"time" axis, as column vector
carrier = cos(wc*filterOrder); %create carrier
r2 = r .* carrier; %r2 has images at DC and twice wc
%design receiver filter to eliminate images:
%Obs: on Matlab, firpmord allows to specify attenuation, e.g.
%lowpass filter of order n=292 (attenuation 0.01):
% [n,fo,mo,w]=firpmord([BW/3 BW/2],[1 0],[0.01 0.01],Fs);
%or lowpass of order n=489 (attenuation 0.001) at stopband:
% [n,fo,mo,w]=firpmord([BW/3 BW/2],[1 0],[0.001 0.001],Fs);
% p_rx = firpm(n,fo,mo,w); %then design the filter with given order
%Instead of firpm, use firls, supported by both Octave and Matlab
filterOrder=489; %filter order
p_rx = firls(filterOrder,[0 BW/Fs BW/Fs 1],[1 1 0 0]); %design filter
disp(['Receiver filter has order = ' num2str(filterOrder)])
xphat = conv(r2,p_rx); %filter the received signal
delayInSamples=delayInSamples+round((length(p_rx)-1)/2);
if useCorrelationForSync==1 %use xcorr or estimated delay
    [R,lags]=xcorr(xp,xphat,10*delayInSamples);
    maxLag=find(abs(R)==max(abs(R)),1,'first');
    firstSymSample = abs(lags(maxLag)) + round(L/2);
else %simply use estimated delay
    firstSymSample = delayInSamples;
end
pamSymbolsRx=xphat(firstSymSample:L:end); %extract symbols
pamSymbolsRx=pamSymbolsRx(1:S); %eliminate tail
%normalize the received constellation
txConstellationPower = mean(constellat.^2);
rxConstellationPower = mean(pamSymbolsRx.^2);
pamSymbolsRx = pamSymbolsRx * ...
    sqrt(txConstellationPower/rxConstellationPower);
[chunksRx,r_hat]=ak_pamdemod(pamSymbolsRx,M);%demodulation
SER = 100*sum(pamSymbols ~= r_hat)/S %estimate SER
symError=pamSymbols-pamSymbolsRx;%calculate signal error
SNRrx_before_detection = 10*log10(mean(pamSymbols.^2)/...
    mean(symError.^2)) %SNR before detection
symError = pamSymbols - r_hat; %after detection
SNRrx_after_detection = 10*log10(mean(pamSymbols.^2)/...
    mean(symError.^2))
Rsym = Fs/L; %symbol rate (in bauds)
Rbps = Rsym * log2(M); %bit rate (in bps)
disp(['Rate = ' num2str(Rbps) ' bps']) %show rate
if (showPlots==1) figs_pamSimple; end %show plots