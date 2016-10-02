%% This script performs the demultiplex and demodulate operations
% in file am_real.wav, which contains digitized AM radio station
% signals from Bay Area, USA. Here, the filtering is done in stages.
close all, clear *
% First the sampling frequency is reduced to half, and then to its
% final value:
Fsfinal=8000; %this will be the final sampling frequency
showPlots = 1; %to show plots
%% Read file
[rx,Fs]=wavread('am_real.wav'); %real-valued signal with AM stations
%in discrete-time, it is centered in 2*pi/3 rad with BW=pi/2 rad
Flo=(710-1024/3)*1e3; %freq. (Hz) of the "local oscillator"
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
freqRF=[640 670 680 690 710 740 790 810]*1000; %RF frequencies in Hz
%% Process all AM stations: Envelope detection and lowpass filtering
for i=1:length(freqRF)
    disp(['Processing AM at ', num2str(freqRF(i)/1000), ' kHz ...']);
    freqDSP=freqRF(i)-Flo; %take in account the carrier frequency
    carrier = exp(-j*2*pi*(freqDSP/Fs)*[0:length(rx)-1]); %carrier
    r = rx.*carrier(:); %1) frequency downconversion
    r = filtfilt(B1,A1,r); %2) filter to eliminate image
    [r,h4]=resample(r,1,2,10); %3) to Fs/2, filter order=40
    r = filtfilt(B2,A2,r); %4) filter again for improved performance
    [r,h5]=resample(r,Fsfinal,Fs/2,20); %5) to Fsfinal, order=2560
    m=abs(r); m=m-mean(m); %6) get magnitude (envelope), subtract DC
    m=filtfilt(B3,A3,m); %7) better filter envelope at Fsfinal
    %% Write wav file to playback later (using e.g. Audacity)
    filename = strcat('AMreal_DemultiplexedFromFreq', ...
        num2str(freqRF(i)/1000), '.wav');
    maxAbs=ceil(max(abs(m))); %wavwrite restricts to [-1,1[
    wavwrite(m/maxAbs,Fsfinal,16,filename);    
    if showPlots == 1
        clf, subplot(311) %first plot is the multiplexed signal at Fs
        [psdIndB,f]=ak_psd(rx,Fs);
        plot(f/1e3,psdIndB);
        maxSpectrum = max(psdIndB)-5;
        grid, hold on, axis tight
       title(['PSDs of AM at ', num2str(freqRF(i)/1000), ' kHz: ' ...
       num2str(Flo/1e3) ' (carrier) + ' num2str(freqDSP/1e3) ' kHz']);
        h2=plot((freqDSP+[-Fcutoff3 -Fcutoff3 Fcutoff3 ...
        Fcutoff3])/1000, [-100 maxSpectrum maxSpectrum -100],'r--');
        subplot(312) %second is the signal filtered and at DC
        [psdIndB,f]=ak_psd(r,Fsfinal);
        h=plot(f/1e3,psdIndB);
        hold on
        h2=plot(([-Fcutoff3 -Fcutoff3 Fcutoff3 Fcutoff3])/1000, ...
         [-100 maxSpectrum maxSpectrum -100],'r--');
        grid, axis tight
        subplot(313) %third plot is the envelope of the signal at DC
        [psdIndB,f]=ak_psd(m,Fsfinal);
        h=plot(f/1e3,psdIndB); %spectrum
        hold on
        h2=plot(([-Fcutoff3 -Fcutoff3 Fcutoff3 Fcutoff3])/1000, ...
            [-100 maxSpectrum maxSpectrum -100],'r--');
        grid, axis tight
    end
    disp('Paused. Press any key to continue...')    
    soundsc(m,Fsfinal); pause %playback demodulated signal
end
