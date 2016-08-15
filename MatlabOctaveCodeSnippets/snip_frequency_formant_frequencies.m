[s,Fs,numbits]=wavread('WeWereAway.wav'); %read wav file
s = s - mean(s(:)); %extract any eventual DC level
Nfft=1024; %number of FFT points
N = length(s); %number of samples in signal
frame_duration = 160; %frame duration
step = 80; %number of samples the window is shifted
order = 10 %LPC order
numFormants = 4 %desired number of formants
%calculate the number of frames in signal
numFrames = floor((N-frame_duration) / step ) + 1
window = hamming(frame_duration); %window for LPC analysis
formants = zeros(numFrames,numFormants); %pre-allocate
for i=1:numFrames %go over all frames
    startSample=1+(i-1)*step; %first sample of frame 
    endSample=startSample + frame_duration - 1; %frame end
    x = s(startSample:endSample); %extract frame samples
    x = x.* window; %windowing
    a = lpc(x,order); %LPC analysis    
    poles = roots(a); %Roots of filter 1/A(z)
    freqsInRads = atan2(imag(poles),real(poles)); %angles
    freqsHz = round(sort(freqsInRads*Fs/(2*pi)))'; %in Hz    
    frequencies=freqsHz(freqsHz>5); %keeps only > 5 Hz
    formants(i,:) = frequencies(1:numFormants); %formants
end
window = blackman(64); %window for the spectrogram
specgram(s,Nfft,Fs,window,round(3/4*length(window)));
ylabel('Frequency (Hz)'); xlabel('Time (sec)'); hold on;
t = linspace(0, N / Fs, numFrames); %abscissa
for i=1:numFormants %plot the formants
    text(t,formants(:,i),num2str(i),'color','blue')
end

