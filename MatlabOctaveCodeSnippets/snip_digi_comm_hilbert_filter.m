N = 52;           % Filter order
F = [0.05 0.95];  % Frequency Vector
A = [1 1];        % Amplitude Vector
W = 1;            % Weight Vector
b  = firls(N, F, A, W, 'hilbert'); %design Hilbert filter

