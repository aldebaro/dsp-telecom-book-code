Fs = 44100; %sampling freq. (all freqs. in Hz)
N  = 100;   %filter order (N+1 coefficientes)
Fc1  = 8400;  % First cuttof frequency
Fc2  = 13200; % Second cuttof frequency
B  = fir1(N, [Fc1 Fc2]/(Fs/2), 'stop', hamming(N+1));

