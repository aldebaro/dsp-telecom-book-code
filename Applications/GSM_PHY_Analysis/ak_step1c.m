%Step 1c -estimate the frequency offset, resample to 4 
%times the symbol rate and correct frequency offset

%Estimate the frequency offset
freq_offset = calc_freq_offset(t,fcch_start,1,showPlots);
%Convert from rad to Hz
frequency_offset_before_Hz=freq_offset*SymbolRate/(2 * pi)

%Resample r (with Fs=500 kHz) to 4x GSM bit rate
oversampling = 4;
Decimation = round(SampleRate*Interpolation/ ...
    (oversampling*SymbolRate));
r = resample(r,Interpolation,Decimation);
%now r has Fs= 4 x 270.8333 kHz = 1.0833 MHz
fcch_start = fcch_start * oversampling;

% Correct the frequency of the whole vector
n=transpose(0:length(r)-1);
r = r .* exp(-1j*n*freq_offset / oversampling);
%r = xlat_freq(r, freq_offset / oversampling);

% Check offset once more
freq_offset=calc_freq_offset(r,fcch_start,oversampling,0);
frequency_offset_after_Hz=freq_offset*SymbolRate/(2 * pi)
