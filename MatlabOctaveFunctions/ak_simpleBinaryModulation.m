function outputWaveform = ak_simpleBinaryModulation( ...
    modulation, bits)
% function outputWaveform = ak_simpleBinaryModulation(
%   modulation, bits)
%Inputs: modulation -> use 'ASK', 'FSK' or 'PSK'
%        bits, generate e.g. with b = floor(2*rand(1,10))
%Example:
% s = ak_simpleBinaryModulation('ASK',floor(2*rand(1,20)))
Fs = 16000; %D/A conversion frequency in Hz
Rsym = 500; %signaling (symbol) rate in bauds
L = round(Fs/Rsym); %oversampling factor
N = length(bits); %number of random bits to be transmitted
n=0:L-1; %index to generate S samples of the waveforms
%Design the pair of waveforms to represent bits 0 and 1:
switch modulation
    case 'ASK'
        A0 = 0; A1 = sqrt(8); w = pi/16;
        s0 = A0 * cos(w * n); s1 = A1 * cos(w * n);
    case 'FSK'
        w0 = pi/16; w1 = 3*pi/16; A = 2;
        s0 = A * cos(w0 * n); s1 = A * cos(w1 * n);        
    case 'PSK'
        w = pi/16; A = 2; 
        s0 = A * cos(w * n);
        s1 = -A * cos(w * n); %same as s1=A*cos(w*n + pi)
end
%Generate whole waveform by selecting the waveform segment
outputWaveform = zeros(1,N*L); %pre-allocate space
for i=1:N
    bitTx = bits(i); %get one bit
    startSample = 1+(i-1)*L; %place to output signal
    if bitTx == 1 %choose segment for bit 1 or 0
        outputWaveform(startSample:startSample+L-1) = s1;
    else
        outputWaveform(startSample:startSample+L-1) = s0;        
    end
end