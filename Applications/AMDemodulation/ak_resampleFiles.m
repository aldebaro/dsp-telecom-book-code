%Resample the files from 44100 to 8000 Hz
N=4; %number of AM signals (or AM radio stations)
%The input files must be named amFile1_Fs44100Hz.wav, ...
%amFile2_Fs44100Hz.wav.wav, ..., amFileN_Fs44100Hz.wav.wav
%The output files will be named amFile1.wav,... , amFileN.wav
myPath='.'; %directory where the files can be found, e.g. 'c:/mydir'
for i=1:N
    inputFileName=[myPath '/amFile' num2str(i) '_Fs44100Hz.wav'];
    [x,Fs_temp]=audioread(inputFileName); 
    if Fs_temp ~= 44100 %Fs_temp must be 44100
        error([inputFileName ' sampling frequency is not 44100 Hz!'])
    end
    %soundsc(x,Fs_temp); disp('Press a key'); pause
    Fs=8000; %new sampling frequency
    y=resample(x,Fs,Fs_temp); %resample from Fs_temp to Fs
    soundsc(y,Fs); disp('Press a key'); pause
    outputFileName=[myPath '/amFile' num2str(i) '.wav'];
    numberOfBitsPerSample = 16; %use 16 bits per sample
    maxAbs=max(abs(y))+eps; %wavwrite restricts to [-1,1[.
    audiowrite(outputFileName, y/maxAbs,Fs,'BitsPerSample',numberOfBitsPerSample); %save
end