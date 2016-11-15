a=1; %zeros in the s-plane
b=-2; c=-1+1j*4; d=-0.1+1j*20; %poles in the s-plane
Hs_num=poly(a); %numerator of H_s(s)
Hs_den=poly([b c conj(c) d conj(d)]) %H_s(s) denominator
k=Hs_den(end)/Hs_num(end); %calculate factor 
Hs_num=k*Hs_num %force a gain=1 at DC (s=0)
Fs=10; %sampling frequency (Hz)
[Hz_num, Hz_den] = bilinear(Hs_num, Hs_den, Fs) %bilinear

