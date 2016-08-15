Fs = 1000; %sampling frequency in Hz
fc = 50; %filter cutoff frequency in Hz
[B,A]=butter(4,fc/(Fs/2)); %4-th order Butterworth filter
N=100; %number of samples in impulse response hn
hn = impz(B,A,100); %impulse response
Hf = fftshift(fft(hn)); %sampled DTFT
equivalentBW = enbw(hn,Fs); %estimate equivalent noise bandwidth
%code to plot the figure continues from here...
freq = -(Fs/2):Fs/N:Fs/2-(Fs/N);
HfdB = 20*log10(abs(Hf));
maxHfMagnitude = max(HfdB);
thresholdPlot = 160; %dB
minHfMagnitude = max(maxHfMagnitude-thresholdPlot,min(HfdB));
%% Plot
clf
plot(freq,HfdB); xlabel('f (Hz)'); ylabel('dB');
hold on;
plot([-equivalentBW -equivalentBW],[minHfMagnitude maxHfMagnitude],'r--',...
    [equivalentBW equivalentBW],[minHfMagnitude maxHfMagnitude],'r--','linewidth',2);
plot([-equivalentBW equivalentBW],[maxHfMagnitude maxHfMagnitude],'r--','linewidth',2);
axis([-Fs/2 Fs/2 minHfMagnitude maxHfMagnitude+1])
title(['ENBW = ' num2str(equivalentBW) ' Hz'])
legend('Actual filter','Equivalent')
writeEPS('digi_comm_enbw');