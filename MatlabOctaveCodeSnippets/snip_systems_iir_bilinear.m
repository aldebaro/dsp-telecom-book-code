%% Passband specifications given in discrete-time:
Wp = pi*[0.2 0.4];   % Passband Frequencies (rad)
Wr = pi*[0.1 0.5];     % Stopband (rejection) Frequencies (rad)
Apass = 3;           % Maximum passband attenuation (ripple) (dB)
Astop = 30;          % Minimum stopband attenuation (dB)
%% Choose convenient sampling frequency
Fs=0.5; % in Hertz
%% Map from discrete to continuous-time using pre-warping
wp=2*Fs*tan(Wp/2); % in rad/s
wr=2*Fs*tan(Wr/2); % in rad/s
%% Design analog filter (use 's' to impose continuous-time)
[N,w_design] = cheb2ord(wp,wr,Apass,Astop,'s')%find the filter order
[Bs,As]=cheby2(N,Astop,w_design,'bandpass','s') %obtain H(s) = Bs/As
figure(1), freqs(Bs,As) %plot the frequency response of H(s)
%% Convert to discrete-time using bilinear
[Bz,Az]=bilinear(Bs,As,Fs) %obtain H(z) from H(s) with given Fs
%% Check some results:
figure(2), freqz(Bz,Az) %plot DTFT of H(z). Check values at Wp and Wr
s=1j*wp; Hs_at_wp=20*log10(abs(polyval(Bs,s)/polyval(As,s)))%cutoff
z=exp(1j*Wp); H_at_Wp=20*log10(abs(polyval(Bz,z)/polyval(Az,z)))
z=exp(1j*Wr); H_at_Wr=20*log10(abs(polyval(Bz,z)/polyval(Az,z)))