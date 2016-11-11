%% Specifications given in discrete-time:
Wp = pi/5;        % Passband Frequency (rad)
Wr = 3*pi/10;     % Stopband Frequency (rad)
Apass = 4;           % Maximum passband attenuation (ripple) (dB)
Astop = 10;          % Minimum stopband attenuation (dB)
%% Choose suitable sampling frequency
Fs=0.5; % in Hertz
%% Map from discrete to continuous-time using pre-warping
wp=2*Fs*tan(Wp/2); % in rad/s
wr=2*Fs*tan(Wr/2); % in rad/s
%% Design analog filter (use 's' to impose continuous-time)
[N,w_cutoff] = buttord(wp,wr,Apass,Astop,'s') %find the filter order
[Bs,As]=butter(N,w_cutoff,'s') %obtain H(s) = Bs/As
%% Convert to discrete-time using bilinear
[Bz,Az]=bilinear(Bs,As,Fs) %obtain H(z) from H(s) with given Fs
%% Check some results:
freqz(Bz,Az) %plot the DTFT of H(z). Now check values at Wp and Wr:
s=1j*w_cutoff; H3dB=20*log10(abs(polyval(Bs,s)/polyval(As,s)))%cutoff
z=exp(1j*Wp); H_at_Wp=20*log10(abs(polyval(Bz,z)/polyval(Az,z)))
z=exp(1j*Wr); H_at_Wr=20*log10(abs(polyval(Bz,z)/polyval(Az,z)))
%% Let the sofware do all the hard work (hiding the "bilinear"):
[N,W_cutoff]=buttord(Wp/pi,Wr/pi,Apass,Astop); %digital filter design
[Bz2,Az2]=butter(N,W_cutoff) %this obtains the same H(z) of line 17