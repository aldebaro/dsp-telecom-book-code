function write_complex_binary(file_name, complex_signal)
% usage: write_complex_binary(file_name, complex_signal)
%
%   Save the vector of complex samples given as 'complex_signal' to a file
%   called 'file_name', use the specific format used by gnuradio.
% Written by Joary, LaPS, UFPA, 2014.

% Create vector to be written
vec_length = 2*length(complex_signal);
write_vec = zeros(1, vec_length);

% Organize data to be transmited
write_vec(1:2:vec_length) = real(complex_signal);
write_vec(2:2:vec_length) = imag(complex_signal);

% Write data to the file
f = fopen(file_name, 'w');
fwrite(f, write_vec, 'float32');
fclose(f);

