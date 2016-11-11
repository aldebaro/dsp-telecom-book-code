B=[0.6 0.1 2.3 4.5]; %numerator
A=[1 -1.2 0.4 5.2 1.1]; %denominator 
[z,p,k]=tf2zp(B,A); %convert to zero-pole for improved 
[sos,g] = zp2sos(z, p, k) %to SOS, g is the overall gain

