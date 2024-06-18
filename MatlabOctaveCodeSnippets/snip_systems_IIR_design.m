Wp=0.3; %normalized passband frequency (rad / pi)
Ws=0.7; %normalized stopband frequency (rad / pi)
Rp=1; %maximum passband ripple in dB
Rs=40; %minimum stopband attenuation in dB
[n,Wn] = buttord(Wp,Ws,Rp,Rs); %find the Butterworth order
[B,A]=butter(n,Wn); %design the Butterworth filter
zp=exp(1j*pi*Wp); zs=exp(1j*pi*Ws); %Z values at Wp and Ws
%% Check if the filter obeys requirements
linearMagWp = abs(polyval(B,zp)/polyval(A,zp)) %mag. at Wp
linearMagWs = abs(polyval(B,zs)/polyval(A,zs)) %mag. at Ws
Dp_result = 1-linearMagWp %linear deviation at Wp (linear)
Rp_result = -20*log10(1-Dp_result) %deviation (ripple) at Wp (dB)
Ds_result = linearMagWs %linear deviation at Ws (linear)
Rs_result = -20*log10(Ds_result) %deviation (ripple) at Ws (dB)

