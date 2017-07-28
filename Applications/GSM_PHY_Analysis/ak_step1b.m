%Step 1b - find the start of frequency correction bursts

%Resample to the baud (symbol) rate for a faster
%Frequency Correction Burst search
if 1
    %use a more precise ratio
    [Interpolation,Decimation]=rat(SymbolRate/SampleRate);
else %faster option
    Interpolation = 13; %used for resampling to 270.8333 kHz
    Decimation = round(SampleRate*Interpolation/SymbolRate);
end
t = resample(r,Interpolation,Decimation); %t is at symbol rate

%Find frequency correction bursts in the file
thresholdForDetectionInRad=1; %1 radian
[fcch_start, fcchStartCandidates] = find_fcch(t,1,length(t), ...
    showPlots, thresholdForDetectionInRad);

disp('Found the following FHCC (first samples):')
fcchStartCandidates
disp('First difference of vector above:')
diff(fcchStartCandidates)
disp('Obs: theoretically, 4 FCCHs within a block are separated by 12500 symbols,')
disp('from 10 frames, each with 156.25*8=1250 symbols. And the last FCCH in a 51-multiframe')
disp('is separated from the next first FHCC by 11*1250=13750 symbols due to the idle frame.');
