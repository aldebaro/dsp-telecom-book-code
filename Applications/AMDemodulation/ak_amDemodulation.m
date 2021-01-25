%% This script performs AM demodulation on mux signal from input file
[rx,Fs]=readwav('amMultiplexedSignals.wav'); %multiplexed AM signals
showPlots = 1; %use 1 to show plots or 0 otherwise
Foff=3.0e3; %filter cutoff frequency (BW=5 kHz for these AM stations)
D=20; %Fs is 256 kHz, but a single AM channel can use Fs2=6400 Hz
Fs2=Fs/D; %Fs2 for decimated channel signal
Norder=100; B=fir1(Norder,Foff/(Fs/2)); %design FIR filter for Fs2
B2=fir1(Norder,Foff/(Fs2/2)); %design FIR filter
Fc=600e3; %IF frequency in Hz (must match the one in Tx)
freqRF=[610 620 630 650]*1000; %RF of each station (must match Tx)
%% Envelope detection and lowpass filtering
for i=1:length(freqRF)
    disp(['Channel at ' num2str(freqRF(i)/1000) 'kHz']);
    freqDSP=freqRF(i)-Fc; %AM channel center frequency at baseband
    carrier = cos(2*pi*(freqDSP/Fs)*[0:length(rx)-1]);
    rbb = rx.*carrier(:); %rbb is a complex-valued signal in baseband
    rbb = filter(B,1,rbb); %filter received signal using B at Fs
    rbb=resample(rbb,1,D); %decimate to 16 kHz
    mx=abs(rbb); %process only the magnitude of rbb
    mx=filter(B2,1,rbb); %filter received signal again using B2 @ Fs2
    mx(1:Norder)=[]; %take out filters transient
    mx=mx-mean(mx); %subtract mean
    if 1 %enable to write wav file
        filename = strcat('AM_DemultiplexedFromFreq' ...
            , num2str(freqRF(i)/1000), '.wav');
        maxAbs=max(abs(mx))+eps; %restrict to [-1,1[
        writewav(mx/maxAbs,Fs2,filename,'16r');
        %wavplay(mx/maxAbs,Fs2,'sync');%Matlab playback with blocking
    end
    %enable to playback demodulated signal:
    soundsc(mx,Fs2); disp('Press any key...'); pause 
    if showPlots == 1
        Nfft=8192; %FFT-length (for plots)
        [spectrum,f]=ak_psd(rx,Fs); %PSD estimation
        clf, subplot(211)
        h=plot(f/1e3,spectrum); %original spectrum
        maxSpectrum = max(spectrum)-2;
        grid, hold on, axis tight, ylabel('PSD (dBm/Hz)')
        title('Multiplexed signal');
        h2=plot((freqDSP+[-Foff -Foff Foff Foff])/1000, [-60 ...
            maxSpectrum maxSpectrum -60],'r--');
        subplot(212)
        [spectrum,f]=ak_psd(rbb,Fs2); %PSD estimation
        h=plot(f/1e3,spectrum); %original spectrum
        hold on
        h2=plot(([-Foff -Foff Foff Foff])/1000, [-60 maxSpectrum ...
            maxSpectrum -60],'r--');
        grid, axis tight, xlabel('f (kHz)'), ylabel('PSD (dBm/Hz)')
        title('Single channel');
        disp('Press any key...');
        pause
    end
end
