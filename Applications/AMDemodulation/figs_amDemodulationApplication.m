close all, clear all
[rx,Fs]=audioread('am_real.wav'); %real-valued signal with AM stations
%in discrete-time, it is centered in 2*pi/3 rad with BW=pi/2 rad
%% Generate first figure
Foff=4.5e3; %filter cutoff frequency (BW=5 kHz for these AM stations)
Fc=(710-1024/3)*1e3; %freq. (Hz) in which the RF signal was centered
[spectrum,f]=ak_psd(rx,Fs);
maxSpectrum = max(spectrum)+2;
%h=plot((Fc+f)/1000,spectrum);
h=plot(f/1000,spectrum);
grid, hold on,
freqRF=[640 670 680 690 710 740 790 810]; %in kHz;
for i=1:length(freqRF)
    %h2=plot(freqRF(i)-Fc/1e3+[-Foff -Foff Foff Foff]/1000, ...
    %    [-120 maxSpectrum maxSpectrum -120],'r--');
    indexOfInterest = find(f>=(1000*freqRF(i))-Fc,1,'first');
    %verticalLine=20:-10:spectrum(indexOfInterest);
    verticalLine=20:-10:-125;
    plot(f(indexOfInterest)/1000*ones(size(verticalLine)), ...
        verticalLine,'xr');
end
%title(['AM stations at [640 670 680 690 710 740 790 810] kHz']);
axis tight; myaxis=axis; myaxis(4)=myaxis(4)+10; axis(myaxis);
xlabel('f (kHz)'), ylabel('PSD (dBm/Hz)')
hold off

writeEPS('spectrumAMRealStations','font12Only')

%% Generate second figure
% final value:
Fsfinal=8000; %this will be the final sampling frequency
%% Read file
Fc=(710-1024/3)*1e3; %freq. (Hz) in which the RF signal was centered
D=floor(Fs/Fsfinal); %decimation factor
%% Design three filters, which will operate at Fs, Fs/2 and Fsfinal
%1) Filter to operate at Fs and eliminate the negative freq. image
Fcutoff1 = (Fs/2)/3; %cutoff is less than BW of all radio stations
Norder1=10; %first filter order
[B1,A1]=butter(Norder1,Fcutoff1/(Fs/2)); %design IIR at Fs
%2) Filter to operate at Fs/2
Fcutoff2 = 30e3; %cutoff was chosen as 30 kHz
Norder2=10; %first filter order
[B2,A2]=butter(Norder2,Fcutoff2/((Fs/2)/2)); %design IIR at Fs/2
%3) Filter to operate at Fsfinal
Fcutoff3=1.5e3; %filter cutoff frequency (BW<5 kHz for AM stations)
Norder3=12; %third filter order
[B3,A3]=butter(Norder3,Fcutoff3/(Fsfinal/2)); %IIR filter at Fsfinal

%Frequencies: (Obs: 670 is foreign and 690 has some (good!) music)
%freqRF=[640 670 680 690 710 740 790 810]*1000; %RF frequencies in Hz
freqRF=[710]*1000; %RF frequencies in Hz
%% Process all AM stations: Envelope detection and lowpass filtering
%for i=1:length(freqRF)
close all
figure1 = figure;
i=1;
disp(['Processing AM at ', num2str(freqRF(i)/1000), ' kHz ...']);
freqDSP=freqRF(i)-Fc; %take in account the carrier frequency
carrier = exp(-j*2*pi*(freqDSP/Fs)*[0:length(rx)-1]); %carrier
r = rx.*carrier(:); %frequency downconversion
subplot(211); [psdIndB,f]=ak_psd(r,Fs); plot(f/1e3,psdIndB);
ylabel('PSD (dBm/Hz)')
axis tight, grid, title('1) After frequency downconversion');
r = filtfilt(B1,A1,r); %filter to eliminate image
subplot(212); [psdIndB,f]=ak_psd(r,Fs); plot(f/1e3,psdIndB);
axis tight, grid, title('2) After first filter');
ylabel('PSD (dBm/Hz)')
[r,h4]=resample(r,1,2,10); %decimate to Fs/2
xlabel('f (kHz)');
annotation(figure1,'textarrow',[0.696428571428571 0.708928571428571],...
    [0.322809523809524 0.226190476190476],'TextEdgeColor','none',...
    'String',{'Peak at 261.3 kHz'});
writeEPS('amRealDemodSteps12','font12Only')
%pause

clf
subplot(211); [psdIndB,f]=ak_psd(r,Fs/2); plot(f/1e3,psdIndB);
title('3) After resampling to use Fs/2=512 kHz');
axis tight, %grid
ylabel('PSD (dBm/Hz)')
r = filtfilt(B2,A2,r); %filter again for improved performance
subplot(212); [psdIndB,f]=ak_psd(r,Fs/2); plot(f/1e3,psdIndB);
axis tight, title('4) After second filter'); %grid
[r,h5]=resample(r,Fsfinal,Fs/2,100); %now decimate to Fsfinal
xlabel('f (kHz)'); ylabel('PSD (dBm/Hz)')
annotation(figure1,'textarrow',[0.223214285714285 0.144642857142857],...
    [0.768047619047623 0.647619047619048],'TextEdgeColor','none',...
    'String',{'Peak','at -250.7 kHz'});
writeEPS('amRealDemodSteps34','font12Only')
%pause

clf
subplot(311); [psdIndB,f]=ak_psd(r,Fsfinal); plot(f/1e3,psdIndB);
axis tight, grid, title('5) After resampling to use Fsfinal=8 kHz');
ylabel('PSD (dBm/Hz)')
m=abs(r); %process the magnitude (envelope)
m=m-mean(m); %extract DC
subplot(312); [psdIndB,f]=ak_psd(m,Fsfinal); plot(f/1e3,psdIndB);
axis tight, grid, title('6) After extracting envelope and its DC');
ylabel('PSD (dBm/Hz)')
hold on
h2=plot(([-Fcutoff3 -Fcutoff3 Fcutoff3 Fcutoff3])/1000, ...
    [-100 maxSpectrum maxSpectrum -100],'r--');
m=filtfilt(B3,A3,m); %filter received envelope at Fsfinal
subplot(313); [psdIndB,f]=ak_psd(m,Fsfinal); plot(f/1e3,psdIndB);
ylabel('PSD (dBm/Hz)')
hold on
h2=plot(([-Fcutoff3 -Fcutoff3 Fcutoff3 Fcutoff3])/1000, ...
    [-100 maxSpectrum maxSpectrum -100],'r--');
xlabel('f (kHz)');
axis tight, grid, title('7) After third filter');
writeEPS('amRealDemodSteps567','font12Only')
%pause
