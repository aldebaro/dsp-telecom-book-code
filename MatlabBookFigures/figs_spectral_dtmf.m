%Dual-Tone Multi-Frequency (DTMF) Signal Detection
%Based on
%From http://www.mathworks.com/products/demos/signaltlbx/dtmf/dtmfdemo.html
%Copyright 1988-2004 The MathWorks, Inc.
%Dual-tone Multi-Frequency (DTMF) signaling is the basis for voice communications control and is widely used worldwide in modern telephony to dial numbers and configure switchboards. It is also used in systems such as in voice mail, electronic mail and telephone banking.
%A DTMF signal consists of the sum of two sinusoids - or tones - with frequencies taken from two mutually exclusive groups. These frequencies were chosen to prevent any harmonics from being incorrectly detected by the receiver as some other DTMF frequency. Each pair of tones contains one frequency of the low group (697 Hz, 770 Hz, 852 Hz, 941 Hz) and one frequency of the high group (1209 Hz, 1336 Hz, 1477Hz) and represents a unique symbol. The frequencies allocated to the push-buttons of the telephone pad are shown below:
%
%                        1209 Hz   1336 Hz   1477 Hz
%                       _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
%                      |         |         |
%                      |         |   ABC   |   DEF   |
%               697 Hz  |    1    |    2    |    3    |
%                       |_ _ _ _ __ _ _ _ __ _ _ _ _
%                       |         |         |
%                       |   GHI   |   JKL   |   MNO   |
%               770 Hz  |    4    |    5    |    6    |
%                       |_ _ _ _ __ _ _ _ __ _ _ _ _
%                       |         |         |
%                       |   PRS   |   TUV   |   WXY   |
%               852 Hz  |    7    |    8    |    9    |
%                       |_ _ _ _ __ _ _ _ __ _ _ _ _
%                       |         |         |
%                       |         |         |         |
%               941 Hz  |    *    |    0    |    #    |
%                       |_ _ _ _ __ _ _ _ __ _ _ _ _
% First, let's generate the twelve frequency pairs
symbol = {'1','2','3','4','5','6','7','8','9','*','0','#'};
lfg = [697 770 852 941]; % Low frequency group
hfg = [1209 1336 1477];  % High frequency group
f  = [];
for c=1:4,
    for r=1:3,
        f = [ f [lfg(c);hfg(r)] ];
    end
end
%Next, let's generate and visualize the DTMF tones
Fs  = 8000;       % Sampling frequency 8 kHz
N = 800;          % Tones of 100 ms (ITU standard allows as short as 40 ms)
t   = (0:N-1)/Fs; % 800 samples at Fs
pit = 2*pi*t;

tones = zeros(N,size(f,2));
for toneChoice=1:12,
    % Generate tone
    tones(:,toneChoice) = sum(sin(f(:,toneChoice)*pit))';
end

if 0
    % Plot all tone
    for toneChoice=1:12,
        subplot(4,3,toneChoice),plot(t*1e3,tones(:,toneChoice));
        title(['Symbol "', symbol{toneChoice},'": [',num2str(f(1,toneChoice)),',',num2str(f(2,toneChoice)),']'])
        set(gca, 'Xlim', [0 25]);
        ylabel('Amplitude');
        if toneChoice>9, xlabel('Time (ms)'); end
    end
    set(gcf, 'Color', [1 1 1], 'Position', [1 1 1280 1024])
    annotation(gcf,'textbox', 'Position',[0.38 0.96 0.45 0.026],...
        'EdgeColor',[1 1 1],...
        'String', '\bf Time response of each tone of the telephone pad', ...
        'FitHeightToText','on');
end

%Let's play the tones of phone number 508 647 7000 for example. Notice that the "0" symbol corresponds to the 11th tone.
if 0
    for i=[5 11 8 6 4 7 7 11 11 11],
        p = audioplayer(tones(:,i),Fs);
        play(p)
        pause(0.3)
    end
end

%Notice that the "0" symbol corresponds to the 11th tone.
%phoneNumber = [9,1,3,2,11,1,7,6,7,4]; %Number 91 3201-7674
phoneNumber = [1,2,3,4,5,6,7,8,9,10,11,12]; %All 12 symbols in sequence
dtmfSignal = zeros(N*length(phoneNumber),1);
for i=1:length(phoneNumber)
    firstSample = ((i-1)*N)+1;
    lastSample = firstSample+N-1;
    dtmfSignal(firstSample:lastSample)=tones(:,phoneNumber(i));
end

clf
filterBWInHz=40; %equivalent FFT bandwidth in Hz
samplingFrequency=8000; %sampling frequenci in Hz
windowShiftInms=1; %window shift in miliseconds
thresholdIndB=40; %discards low power values below it
ak_specgram(dtmfSignal,filterBWInHz,samplingFrequency,windowShiftInms,thresholdIndB)
set(gca,'ytick',[lfg,hfg])
grid
myaxis=axis;
myaxis(3)=520; myaxis(4)=1640;
axis(myaxis)
colorbar

if 0 %in case one wants to save the signal (without silence spaces among tones)
    normalizedSignal = dtmfSignal/max(abs(dtmfSignal)); %force to range [-1, 1]
    normalizedSignal = (2^15 - 1)*normalizedSignal; %force to range [-32767, 32767]
    audiowrite('dtmf_tones.wav',int16(normalizedSignal),samplingFrequency)
end

writeEPS('dtmf_spectrogram','font12Only');


phoneNumber = [3,2,11,1,7,6,7,4]; %Number 3201-7674
dtmfSignal = zeros(N*length(phoneNumber),1);
for i=1:length(phoneNumber)
    firstSample = ((i-1)*N)+1;
    lastSample = firstSample+N-1;
    dtmfSignal(firstSample:lastSample)=tones(:,phoneNumber(i));
end
clf
ak_specgram(dtmfSignal,filterBWInHz,samplingFrequency,windowShiftInms,thresholdIndB)
set(gca,'ytick',[lfg,hfg])
grid
myaxis=axis;
myaxis(3)=520; myaxis(4)=1640;
axis(myaxis)
colorbar
writeEPS('dtmf_spectrogram_exercise','font12Only');
