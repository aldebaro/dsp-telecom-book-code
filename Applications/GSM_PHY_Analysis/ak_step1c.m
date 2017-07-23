%Step 1c - estimate the frequency offset and correct it.
%Use resample to 4 times the symbol rate.

oversampling=1; %signal is at symbol rate
if 0 %use only first FB
    freq_offset = calc_freq_offset(t,fcch_start,oversampling,showPlots);
else %Estimate the frequency offset as an average over all found FBs
    freq_offset = 0;
    for i=1:length(fcchStartCandidates)
        freq_offset = freq_offset + calc_freq_offset(t,...
            fcchStartCandidates(i),oversampling,showPlots);
    end
    freq_offset = freq_offset/length(fcchStartCandidates);
end

%Convert from rad to Hz (recall signal is at baud rate)
frequency_offset_before_Hz=freq_offset*SymbolRate/(2 * pi);
disp(['Original frequency offset = ' num2str(frequency_offset_before_Hz) ' Hz']);

%Resample original signal to 4x GSM baud rate
oversampling = 4;
if 1
    %use a more precise ratio
    [Interpolation,Decimation]=rat(oversampling*SymbolRate/SampleRate);
else %faster option
    Interpolation = 13; %used for resampling to 270.8333 kHz
    Decimation = round(SampleRate*Interpolation/(oversampling*SymbolRate));
end
r = resample(r,Interpolation,Decimation);
%now r has Fs= 4 x 270.8333 kHz = 1.0833 MHz
fcch_start = fcch_start * oversampling; %update FCCH start sample

% Correct the frequency of the whole vector
n=transpose(0:length(r)-1);
r = r .* exp(-1j*n*freq_offset / oversampling);

% Check offset once more, just for fun
freq_offset=calc_freq_offset(r,fcch_start,oversampling,0);
frequency_offset_after_Hz=freq_offset*SymbolRate/(2 * pi);
disp(['Residual frequency offset after correction = ' num2str(frequency_offset_after_Hz) ' Hz']);