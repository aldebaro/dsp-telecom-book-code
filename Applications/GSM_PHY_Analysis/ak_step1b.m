%Step 1b - find the start of a frequency correction burst

%Some constants
Interpolation = 13; %used for resampling to 270.8333 kHz

%Resample to the baud (symbol) rate for a faster 
%Frequency Correction Burst search
Decimation = round(SampleRate*Interpolation/SymbolRate);
%Decimation=24, such that 500*13/24=270.8333
%r has Fs=500 kHz  and t has Fs=270.8333 kHz
t = resample(r,Interpolation,Decimation);

%Find first frequency correction burst in the file, but
%searching only the first 15000 samples
fcch_start = find_fcch(t,1,15000,showPlots)
