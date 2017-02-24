function figs_systems_showDACFilterEffect(BW)
% BW - signal bandwidth BW
%Example: Fc=80e3 for bad situation and Fc=25e3 for good one
Fc = BW; %Fc is the cutoff frequency that imposes the signal BW
%% Mimic the analog reconstruction filter after a DAC using two
%sampling frequencies, with the higher one playing the role of analog
%processing. 
randn('state',0); %reset Gaussian random number generator
N=10000; %number of samples
Fs=200e3; %sampling frequency in Hz
P=10; %upsampling factor
Fs2=P*Fs; %new sampling frequency, to mimic analog processing
x=sqrt(100)*randn(1,N); %white Gaussian with arbitrary power=10 Watts
[B1,A1]=butter(20,Fc/(Fs/2)); %filter with cutoff freq. of 100 kHz
y=filter(B1,A1,x); %generate a band-limited signal
xu=zeros(1,P*length(y)); %create zeros for upsampling
xu(1:P:end)=y; %perform upsampling
[B2,A2]=butter(5,Fc/(Fs2/2)); %filter at Fs2 and f_cutoff=100 kHz
yu=filter(B2,A2,xu); %generate band-limited signals
%% Plot graphs
% 1st plot
[S,f]=ak_psd(xu,Fs2); %plot the signal at higher sampling rate
clf, subplot(211)
plot(f/1e3,S);xlabel('f (kHz)');ylabel('PSD (dBm/Hz)');
hold on
[H,w]=freqz(B2,A2); %superimpose the filter
plot(Fs2*w/(2*pi)/1e3,20*log10(abs(H)),'r'); %positive and negative..
plot(-Fs2*(fliplr(w))/(2*pi)/1e3,fliplr(20*log10(abs(H))),'r');%freqs
grid, set(gca,'XTick',[(-10*Fs:Fs:10*Fs)/1e3])
axis([-5*Fs/1e3 5*Fs/1e3 -150 10]) %zoom it
title(['Fs=' num2str(Fs/1e3) ' kHz and BW=' num2str(Fc/1e3) ' kHz'])
h=legend('Sampled signal','Analog Filter');
set(h,'Location','SouthWest');
ylabel('|Y(e^{2\pi T_s f}| (dB)')%it's PSD, but explain as |.| instead
% 2nd plot
[S,f]=ak_psd(yu,Fs2); %signal after the DAC "reconstruction filter"
subplot(212)
plot(f/1e3,S);xlabel('f (kHz)');ylabel('PSD (dBm/Hz)');
grid, set(gca,'XTick',[(-10*Fs:Fs:10*Fs)/1e3])
myaxis = axis; 
axis([-2*Fs/1e3 2*Fs/1e3 myaxis(3) myaxis(4)]); %zoom it
h=legend('Analog signal');
set(h,'Location','NorthWest');
ylabel('|Y(f)| (dB)') %it is a PSD, but explain as |Y(f)| instead