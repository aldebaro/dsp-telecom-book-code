close all, clear all
rx=read_complex_binary('am_usrp710.dat'); %read file in binary format
rx(1:20)=[]; %take out transient
Fs=256e3; %sampling frequency (Hz)

%% Generate first figure
Foff=4.5e3; %filter cutoff frequency (BW=5 kHz for these AM stations)
Fc=710*1e3; %carrier frequency
[spectrum,f]=ak_psd(rx,Fs);
maxSpectrum = max(spectrum)+2;
h=plot((Fc+f)/1000,spectrum);
grid, hold on,
freqRF=[640 670 680 690 710 740 790 810]; %in kHz;
for i=1:length(freqRF)
    h2=plot(freqRF(i)+[-Foff -Foff Foff Foff]/1000, ...
        [-30 maxSpectrum maxSpectrum -30],'r--');
end
title(['AM stations at [640 670 680 690 710 740 790 810] kHz']);
axis tight; myaxis=axis; myaxis(4)=myaxis(4)+10; axis(myaxis);
xlabel('f (kHz)'), ylabel('PSD (dBm/Hz)')

%writeEPS('amDemodulation','font12Only')
writeEPS('spectrumAMStations','font12Only')
%pause
