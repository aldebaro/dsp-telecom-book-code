Fs = 11025; %define sampling rate (Hz)
fc= 1500; %cosine frequency (Hz)
recordingDuration =1; %duration of recording, in seconds 
r=audiorecorder(Fs,16,1);
while 1 %infinite loop, stop with CTRL+C
    recordblocking(r,recordingDuration);
    inputSignal = getaudiodata(r);
    p=audioplayer(r);
    subplot(211), plot(inputSignal); %graph in time domain
    subplot(212), pwelch(double(inputSignal)); %in frequency domain
    drawnow %Force the graphics to update immediately inside the loop
end
