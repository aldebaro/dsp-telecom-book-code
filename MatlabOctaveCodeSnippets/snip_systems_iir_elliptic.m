%% Specifications given in continuous-time:
Fp = 100;        % Passband Frequency (Hz)
Fr = 150;        % Stopband Frequency (Hz)
Apass = 4;           % Maximum passband attenuation (ripple) (dB)
Astop = 20;          % Minimum stopband attenuation (dB)
Fs=500; % in Hertz
%% Convert to discrete-time using the fundamental relation w = W Fs
Wp=2*pi*Fp/Fs; %in rad
Wr=2*pi*Fr/Fs; %in rad
%% Convert to continuous-time using pre-warping. Can pick another Fs
Fs2=0.5; %could continue with Fs=500, but will illustrate a new value
wp=2*Fs2*tan(Wp/2); % in rad/s
wr=2*Fs2*tan(Wr/2); % in rad/s
%% Design analog filter (use 's' to impose continuous-time)
[N,w_passband]=ellipord(wp,wr,Apass,Astop,'s') %find the filter order
[Bs,As]=ellip(N,Apass,Astop,w_passband,'s') %obtain H(s) = Bs/As
%% Convert to discrete-time using bilinear
[Bz,Az]=bilinear(Bs,As,Fs2) %obtain H(z) from H(s) with given Fs
%% Check some results:
%freqz(Bz,Az) %plot the DTFT of H(z). Now check values at Wp and Wr:
s=1j*wp; Hs_at_wp=20*log10(abs(polyval(Bs,s)/polyval(As,s)))
s=1j*wr; Hs_at_wr=20*log10(abs(polyval(Bs,s)/polyval(As,s)))
z=exp(1j*Wp); Hz_at_Wp=20*log10(abs(polyval(Bz,z)/polyval(Az,z)))
z=exp(1j*Wr); Hz_at_Wr=20*log10(abs(polyval(Bz,z)/polyval(Az,z)))
%% Let the sofware do all the hard work (hiding the "bilinear"):
[N,W_passband]=ellipord(Wp/pi,Wr/pi,Apass,Astop); %digital filter 
[Bz2,Az2]=ellip(N,Apass,Astop,W_passband) %obtains same H(z)