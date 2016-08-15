if 0
wn = 100; %natural frequency in rad/s
zeta = [0.5 0.707 1 2]; %damping ratios
N=500; %number of points for plot
w=wn*linspace(0.1,10,N); %angular frequency in rad/s
s=1j*w; %Laplace: s=jw
Hs1=zeros(length(zeta),N); %pre-allocate space
Hs2=zeros(length(zeta),N);
for i=1:length(zeta)
    Hs1(i,:) = wn^2./(s.^2+2*zeta(i)*wn*s+wn^2); %2nd order
    Hs2(i,:) = (2*zeta(i)*wn*s+wn^2)./(s.^2+2*zeta(i)*wn*s+wn^2); %another 2nd order
end
%% Plots
clf
subplot(121)
semilogx(w/wn,20*log10(abs(Hs1)))
xlabel('\omega / \omega_n'); ylabel('|H(w)| (dB)')
legend('\zeta=0.5','\zeta=0.707','\zeta=1','\zeta=2','Location',...
    'SouthWest')
title('a) Zeros at infinite')
subplot(122)
semilogx(w/wn,20*log10(abs(Hs2)))
xlabel('\omega / \omega_n'); ylabel('|H(w)| (dB)')
legend('\zeta=0.5','\zeta=0.707','\zeta=1','\zeta=2','Location',...
    'SouthWest')
title('b) Finite zeros')
writeEPS('secondOrderSys')
end

wn = 20; %natural frequency in rad/s
zeta = [0.5 0.707 1 2]; %damping ratios
clf
t=0:6e-4:0.6;
y=zeros(length(zeta),length(t));
for i=1:length(zeta)
    sys = tf([2*zeta(i)*wn wn^2],[1 2*zeta(i)*wn wn^2]);
    y(i,:)=step(sys,t);
    S = stepinfo(sys,'RiseTimeLimits',[0.05,0.95])
end
plot(t,y), xlabel('time (s)'), ylabel('\phi_o(t) (rad)')
title('Step response')
axis([0 0.6 0 1.4])
legend('\zeta=0.5','\zeta=0.707','\zeta=1','\zeta=2','Location',...
    'SouthEast')
writeEPS('pllStepResponse')

t=0:6e-4:0.5;
zeta = [0.5 2]; %damping ratios
ramp=t         % Your input signal
y=zeros(length(zeta),length(t));
for i=1:length(zeta)
    sys = tf([2*zeta(i)*wn wn^2],[1 2*zeta(i)*wn wn^2]);
    y(i,:)=lsim(sys,ramp,t)
end
plot(t,y)
xlabel('time (s)'), ylabel('\phi_o(t) (rad)')
title('Ramp response')
%axis([0 0. 0 1.4])
legend('\zeta=0.5','\zeta=2','Location',...
    'SouthEast')
writeEPS('pllRampResponse')

%% 
clear all
wn = 20; %natural frequency in rad/s
t=0:6e-4:1.5;
zeta = [0.5 0.707 2]; %damping ratios
%step=ones(size(t));         % Your input signal
ramp=t;         % Your input signal
y=zeros(length(zeta),length(t));
for i=1:length(zeta)
    sys = tf([1 0 0],[1 2*zeta(i)*wn wn^2]);
    y(i,:)=lsim(sys,ramp,t)
end
plot(t,y)
xlabel('time (s)'), ylabel('\epsilon(t) (rad)')
legend('\zeta=0.5','\zeta=0.707','\zeta=2','Location',...
    'NorthEast')
writeEPS('pllErrorResponse')