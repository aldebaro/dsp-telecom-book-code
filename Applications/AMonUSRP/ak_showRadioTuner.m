%This code deals with the complex signal from USRP. It uses both real
%and imag parts to get the magnitude for envelope detection.
rx=read_complex_binary('am_usrp710.dat'); %read file in binary format
rx(1:20)=[]; %take out transient
Fs=256e3; %sampling frequency (Hz)
Foff=4.5e3; %filter cutoff frequency (BW=5 kHz for these AM stations)
D=16; %decimation factor to get 16 kHz
Fs2=Fs/D; %Fs2 = 16 kHz
Norder=100; B=fir1(Norder,Foff/(Fs/2)); %design FIR filter
B2=fir1(Norder,Foff/(Fs2/2)); %design FIR filter
Fc=710*1e3; %carrier frequency
[spectrum,f]=ak_psd(rx,Fs);
maxSpectrum = max(spectrum)-2;
clf; h=plot(f,spectrum);
xlabel('f (Hz)')
ylabel('PSD (dBm/Hz)')
grid, hold on, axis tight
freqRF=[640 670 680 690 710 740 790 810]*1000; %690 has some music!
%freqRF=[590:10:830]*1000; %all AM stations within signal spectrum
%% Envelope detection and lowpass filtering
for i=1:length(freqRF)
    disp(['Channel at ' num2str(freqRF(i)/1000) 'kHz']);
    freqDSP=freqRF(i)-Fc; %AM channel center frequency at baseband
    carrier=exp(-j*2*pi*(freqDSP/Fs)*[0:length(rx)-1]); %complex exp
    h2=plot(freqDSP+[-Foff -Foff Foff Foff], ...
        [0 maxSpectrum maxSpectrum 0],'r--');
    rbb = rx.*carrier(:); %rbb is a complex-valued signal in baseband
    rbb = filter(B,1,rbb); %filter received signal using Fs
    rbb=resample(rbb,1,D); %decimate to 16 kHz
    mx=abs(rbb); %process only the magnitude of rbb    
    mx=filter(B2,1,mx); %additional filtering, using Fs2 (decimated)
    mx(1:Norder)=[]; %take out filters transient
    mx=mx-mean(mx); %subtract mean
    if 0 %enable to write wav files
        filename = strcat('AM_Freq', num2str(freqRF(i)/1000),'.wav');
        maxAbs=max(abs(mx))+eps; %restrict to [-1,1[.
        writewav(mx/maxAbs,Fs2,filename,'16r');
    end
    soundsc(mx,Fs2); %playback demodulated signal
    %wavplay(m2/maxAbs,Fs2,'sync'); %playback with blocking
    display('Press any key after sound stops...'); pause
end
title(['Playback of AM station at [',num2str(freqRF/1000), '] kHz']);