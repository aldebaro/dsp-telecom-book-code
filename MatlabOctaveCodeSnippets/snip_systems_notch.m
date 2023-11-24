f_notch=60.0; % notch frequency in Hz
BW_3dB=4.0;  % 3 dB bandwidth in Hz
Fs=400; % sampling frequency in Hz
Omega_0=2*pi*(f_notch/Fs); % digital angular frequency
r=1-(BW_3dB/Fs)*pi; % poles radius
notch_zeros = [1*exp(1i*Omega_0) 1*exp(-1i*Omega_0)];                
notch_poles = [r*exp(1i*Omega_0) r*exp(-1i*Omega_0)];
Bz_notch=poly(notch_zeros); % numerator B(z)
Az_notch=poly(notch_poles); % denominator A(z)
freqz(Bz_notch, Az_notch) % show frequency response
