%Step 1 - Read in the signal and apply low pass filtering
global showPlots %show plots if equal to 1
%Some extra constants
SymbolRate = 270833.3333; %bauds
if 0
    %Obs: signal bandwidth in Hz coincides with SymbolRate in GMSK
    %Hence, consider the spectrum of interest is from -SymbolRate/2 to
    %SymbolRate/2, such that:
    FilterBandWidth = SymbolRate/2; %filter cutoff frequency
else
    FilterBandWidth = 100e3;
end
filterOrder=40; %lowpass filter order. Needs to be an even number

%read data
[r_original, information] = ak_getGSMDataFromFile(fileNumber,folder);
SampleRate = information.sampleRate;
%ak_psd(r_original,2);
%disp(['Sample rate = ' num2str(SampleRate/1e3) ' kHz'])

if 0 %if wants to tune into another GSM channel
    %pi = 500k as w0 = 400k
    w0=-0.6*pi;
    %w0=2*pi/5;
    %w0=800e3/(SampleRate/2)*pi;
    n=0:length(r_original)-1;
    r_original=r_original.*exp(-1j*w0*n');
end

%Use a low pass filter to clean up the signal
filt = fir1(filterOrder, FilterBandWidth/(SampleRate/2)); %normalize by Nyquist frequency
r = conv(r_original,filt); %r has length(r_original)+filterOrder samples
r=r((filterOrder/2)+1:end); %compensate (eliminate) filter's group delay
r=r(1:length(r_original)); %now: length(r)=length(r_original)

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
    %ak_psd(r,SampleRate);
    %axis([-250 250 -80 20])
    title('PSD of filtered complex envelope');
    ylabel('dB / Hz');
    xlabel('Frequency (kHz)');
end
