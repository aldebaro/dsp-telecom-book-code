%Step 1 - Read in the signal and apply low pass filtering

% Select the file to analyze
FileName='GSMSP_20070204_robert_dbsrx_953.6MHz_128.cfile';
SampleRate = 500000; %in Hz
%FileName='GSMSP_20070204_robert_dbsrx_941.0MHz_128.cfile';
%SampleRate = 500000;
%FileName='GSMSP_20070204_robert_dbsrx_953.6MHz_64.cfile';
%SampleRate = 1000000;

%Some constants
FilterBandWidth = 100000; %Hz
SymbolRate = 270833; %bauds
Interpolation = 13; %used for resampling
showPlots = 1; %show plots if equal to 1

% Load file
r_original = read_complex_binary(FileName);

%Use a low pass filter to clean up the signal
filt = fir1(40, 2*FilterBandWidth/SampleRate);
r = conv(r_original,filt);

if showPlots == 1
    Nfft = 512; %num of FFT points
    Hfilt=fftshift(fft(filt,Nfft));
    Hfilt = 20*log10(abs(Hfilt));
    %Hfilt = Hfilt + 10; %max(Hpsd.Data) + 1; %to visualize
    subplot(211)
    Pr=pwelch(r_original, Nfft+1, 0, Nfft, SampleRate);
    Pr=fftshift(Pr);
    DeltaF = SampleRate/Nfft;
    f=(-SampleRate/2:DeltaF:SampleRate/2-DeltaF)/1000;
    plot(f, Hfilt, 'k');
    hold on
    plot(f,10*log10(Pr));
    hold off
    axis([-250 250 -80 20])
    ylabel('dB / Hz');
    title('PSD of original complex envelope and filter response');

    subplot(212)
    Pr=pwelch(r, Nfft+1, 0, Nfft, SampleRate);
    Pr=fftshift(Pr);
    plot(f,10*log10(Pr));
    axis([-250 250 -80 20])    
    title('PSD of filtered complex envelope');
    ylabel('dB / Hz');
    xlabel('Frequency (kHz)');
end
