Fs = 44100;   %sampling rate, must be the same as Java code
numSamples = Fs/2; %number of samples for DAC and ADC of soundboard
while 1 %eternal loop, break it with CTRL+C
    outputSignal=randn(numSamples,1); %generate white Gaussian noise
    wavplay(outputSignal, Fs, 'async');  %non-blocking playback
    inputSignal  = wavrecord(numSamples, Fs, 'int16'); %record
    subplot(211), plot(inputSignal); axis tight %graph in time domain 
    subplot(212), psd(double(inputSignal)); %in frequency domain
    drawnow %Force the graphics to update immediately inside the loop
end