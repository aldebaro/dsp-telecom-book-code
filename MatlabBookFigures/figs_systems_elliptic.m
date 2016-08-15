Apass=5; %maximum ripple at passband
Astop=80; %minimum attenuation at stopband
%% Lowpass Elliptic %%%%%%%%% 
Fp=100; Wp=2*pi*Fp; %passband frequency
Fr=120; Wr=2*pi*Fr; %stopband frequency
[N, Wp] = ellipord(Wp, Wr, Apass, Astop, 's') %find order
[z,p,k]=ellip(N,Apass,Astop,Wp,'s'); %design filter
B=k*poly(z); A=poly(p); %convert zero-poles to transfer function
[H,w]=freqs(B,A); %calculate frequency response
ak_plotFrequencyResponseAndMask(H,w,Apass,Astop,Wp,Wr,'lowpass');
writeEPS('lowpassElliptic');
%% Higpass Elliptic %%%%%%%%%
Fr=100; Wr=2*pi*Fr; %stopband frequency
Fp=120; Wp=2*pi*Fp; %passband frequency
[N, Wp] = ellipord(Wp, Wr, Apass, Astop, 's') %find order
[z,p,k]=ellip(N,Apass,Astop,Wp,'high','s'); %design filter
B=k*poly(z); A=poly(p); %convert zero-pole to transfer function
[H,w]=freqs(B,A); %calculate frequency response
ak_plotFrequencyResponseAndMask(H,w,Apass,Astop,Wp,Wr,'highpass');
writeEPS('highpassElliptic');
%% Bandpass Elliptic %%%%%%%%
Fr1=10; Wr1=2*pi*Fr1; %first stopband frequency
Fp1=20; Wp1=2*pi*Fp1; %first passband frequency
Fp2=120; Wp2=2*pi*Fp2; %second passband frequency
Fr2=140; Wr2=2*pi*Fr2; %second stopband frequency
[N,Wp]=ellipord([Wp1 Wp2],[Wr1 Wr2],Apass,Astop,'s') %find order
[z,p,k]=ellip(N,Apass,Astop,Wp,'s');%design filter
B=k*poly(z); A=poly(p); %convert zero-pole to transfer function
[H,w]=freqs(B,A); %calculate frequency response
ak_plotFrequencyResponseAndMask(H,w,Apass,Astop,Wp,...
    [Wr1 Wr2],'bandpass');
writeEPS('bandpassElliptic');
%% Bandpass Butterworth %%%%%%%%%%%
[N, Wn]=buttord([Wp1 Wp2],[Wr1 Wr2],Apass,Astop,'s')%find order
[z,p,k]=butter(N,Wn,'s'); %design Butterworth filter
B=k*poly(z); A=poly(p); %convert zero-pole to transfer function
[H,w]=freqs(B,A); %calculate frequency response
ak_plotFrequencyResponseAndMask(H,w,Apass,Astop,Wp,...
    [Wr1 Wr2],'bandpass');
subplot(211); axis([1e-2 1e4 -150 0])
writeEPS('bandpassButterworth');