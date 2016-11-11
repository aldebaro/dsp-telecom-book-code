N=5; %filter order for the lowpass prototype (e.g., bandpass is 2*N)
Rp=0.1; %maximum ripple in passband (dB)
Rs=30; %minimum attenuation in stopband (dB)
[B,A]=ellip(N,Rp,Rs,0.4,'high'); %highpass, cutoff=0.4 rad
[B,A]=ellip(N,Rp,Rs,[0.5 0.8]); %bandpass, BW=[0.5, 0.8], order=2*N
[B,A]=ellip(N,Rp,Rs,[0.5 0.8],'stop'); %BW=[0.5, 0.8], order=2*N