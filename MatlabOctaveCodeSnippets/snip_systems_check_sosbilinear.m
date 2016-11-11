wn=2; %natural frequency in rad/s
zeta=0.5; %damping ratio
Fs=10*wn/(2*pi); %Fs chosen as 10 times the natural freq. in Hz
Wn=wn*(1/Fs); %convert angular freq. from continuous to discrete-time
if 1 %Hs=wn^2/(s^2+2*zeta*wn*s+wn^2)
    [Bz,Az]=bilinear(wn^2,[1 2*zeta*wn +wn^2],Fs) %to compare below
    Bz2=Wn^2*[1 2 1]; %expression from this textbook
    Az2=[4+4*zeta*Wn+Wn^2 2*Wn^2-8 4-4*zeta*Wn+Wn^2]; %from textbook
else %Hs=(2*zeta*wn*s+wn^2)/(s^2+2*zeta*wn*s+wn^2) %Another H(s)
    [Bz,Az]=bilinear([2*zeta*wn wn^2],[1 2*zeta*wn +wn^2],Fs)%compare
    Bz2=[4*zeta*Wn+Wn^2 2*Wn^2 Wn*(Wn-4*zeta)]; %from textbook 
    Az2=[4+4*zeta*Wn+Wn^2 2*Wn^2-8 4-4*zeta*Wn+Wn^2]; %from textbook
end
Bz2=Bz2/Az2(1), Az2=Az2/Az2(1) %normalize as done by bilinear.m