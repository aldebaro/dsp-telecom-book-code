Tsym = 1/8000; % Symbol period (s)
Fs = 24000; % Sampling frequency. Oversampling of 3
r = 0.5; % Roll-off factor
P = 31; % Pulse duration in samples, an odd integer
L = Tsym*Fs; %oversampling factor
groupDelay = (P-1)/(2*L); %group delay in samples
%1) Continuous-time version:
t = -groupDelay*Tsym:1/Fs:groupDelay*Tsym; %Sampling time
p = (sin(pi*t/Tsym)./(pi*t/Tsym)).*(cos(r*pi*t/Tsym)./ ...
    (1-(2*r*t/Tsym).^2));
p(1:L:end)=0; %correct numerical errors: force zeros
p(groupDelay*L+1)=1; %recover the value due to 0/0
%2) Discrete-time version: (requires only L and r)
n = -groupDelay*L:groupDelay*L; %Sampling instants
p2 = (sin(pi*n/L)./(pi*n/L)).*(cos(r*pi*n/L) ./ ...
(1-(2*r*n/L).^2));
p2(1:L:end)=0; %correct numerical errors: force zeros
p2(groupDelay*L+1)=1; %recover the value due to 0/0
%3) Use Matlab instead (not available on Octave):
%p3 = rcosine(1,L,'fir/normal',r,groupDelay);
%4) Use the companion function ak_rcosine (it mimics Matlab syntax)
p4 = ak_rcosine(1,L,'fir/normal',r,groupDelay);
%plot to compare two versions (they should be equal):
plot(p,'-+'),hold on,plot(p2,'r'),legend('Ver 1','Ver 2')