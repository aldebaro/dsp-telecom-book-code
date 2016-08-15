exampleNumber=1; %choose 1 (spectrum analyzer) or 2 (digital filter)
Fs = 8000;   %define sampling rate (Hz)
%create an audio recorder object:
microphone = dsp.AudioRecorder('NumChannels',1,'SampleRate',Fs);
if exampleNumber==1
    specAnalyzer = dsp.SpectrumAnalyzer; %spectrum analyzer object
else
    [B,A]=butter(4,0.05); %4-th order lowpass Butterworth filter
    filterMemory=[]; %initialize the filter's memory
    speaker = dsp.AudioPlayer('SampleRate',Fs); %create audio player
end
disp('Infinite loop, stop with CTRL+C...');
while 1 %infinite loop, stop with CTRL+C
    audio = step(microphone); %record audio
    if exampleNumber==1 %spectrum analyzer
        step(specAnalyzer,audio); %observe audio in frequency domain
    else %perform digital filtering
        [output,filterMemory]=filter(B,A,audio,filterMemory);
        step(speaker, output); %send filtered audio to player
    end
end