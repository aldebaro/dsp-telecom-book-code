global showPlots syncBits syncSymbols

showPlots=1; %use 1 to show plots

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1) Pre-processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%synchronism bits
syncBits = [1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, ...
    1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, ...
    1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, ...
    0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 1];
%map synchronism bits to GMSK symbols
syncSymbols = T_SEQ_gen(syncBits);

rand('twister',0);
randn('state',0);

% Select the file to analyze
FileName='GSMSP_20070204_robert_dbsrx_953.6MHz_128.cfile';
SampleRate = 500000; %in Hz

%Some constants:
FilterBandWidth = 100000; %Hz
SymbolRate = 270833; %bauds
Interpolation = 13; %used for resampling
showPlots = 1; %show plots if equal to 1

% Load file with Fs = 500 kHz
r_original = read_complex_binary(FileName);

%Use a low pass filter to clean up the signal
filt = fir1(40, 2*FilterBandWidth/SampleRate);
r = conv(r_original,filt);

%Upconvert to 4 times the GSM symbol rate:4 x 270.8333 kHz
oversampling = 4;
Interpolation = 13; %used for resampling
Decimation = 6; %note: 13/6*500/4 = 270.8333 kHz
%make r to have approximately Fs= 4 x 270.8333 kHz
r = resample(r,Interpolation,Decimation);
SampleRate2 = Interpolation / Decimation * SampleRate;

%There is a frequency offset between the Tx and Rx:
frequency_offset_Hz = 8.6956e+003; % in Hz
%Convert from Hz to rad
freq_offset_rad = 2*pi*frequency_offset_Hz/SampleRate2;

% Correct the frequency of the whole vector
n=transpose(0:length(r)-1);
r = r .* exp(-j*n*freq_offset_rad);

%sample where a FCCH was estimated to begin
if 0 %in case wants to learn with the ak_step2a script
    fcch_start = 56848-5000;
    ak_step2a
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%2) Find three FHCC via the maximum crosscorrelation
%   between syncSymbols and r
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The signal r has sampling rate=SampleRate2 while
% signal syncSymbols has sampling rate=SymbolRate.
% Recall that SampleRate2 = oversampling * SymbolRate
% and pay attention when calculating the crosscorrelation.
% Consider that the three FHCC are in the intervals of r:
startSamples = [56838 106838 156838];
endSamples = startSamples + 650;
%for example, the 1st FHCC is between 56838 and 57488 of r