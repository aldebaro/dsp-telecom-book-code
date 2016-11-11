Wp=0.3; %normalized passband frequency (rad / pi)
Ws=0.7; %normalized stopband frequency (rad / pi)
Rp=1; %maximum passband ripple in dB
Rs=40; %minimum stopband attenuation in dB
[n,Wn] = buttord(Wp,Ws,Rp,Rs); %find the Butterworth order
[B,A]=butter(3*n,Wn); %design the Butterworth filter
zp=exp(j*pi*Wp); zs=exp(j*pi*Ws); %Z values at Wp and Ws
linearMagWp = abs(polyval(B,zp)/polyval(A,zp)) %mag. at Wp
linearMagWs = abs(polyval(B,zs)/polyval(A,zs)) %mag. at Ws
D_p = 1-linearMagWp %linear deviation at Wp (linear)
R_p = -20*log10(1-D_p) %deviation (ripple) at Wp (dB)
D_s = linearMagWs %linear deviation at Ws (linear)
R_s = -20*log10(D_s) %deviation (ripple) at Ws (dB)

