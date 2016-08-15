clear all
close all
Rsym=500;
BW=200;
temp=[-BW 0 BW];
x=[ (temp-2*Rsym) (temp-Rsym) temp (temp+Rsym) (temp+2*Rsym)];
triangle=[0 1 0];
y=[triangle triangle triangle triangle triangle]
plot(x,y);
axis tight
newAxis=axis;
delta = -100;
ypos = 0.5;
text(newAxis(1)+delta/6, ypos, '...', 'FontSize',20)
text(newAxis(2)-delta+delta/6, ypos, '...', 'FontSize',20)
xlabel('frequency (Hz)')
ylabel('P_s(f)')
writeEPS('nyquistCriterionExample');

%Raised-cosine. Because the pulse must be truncated, we consider the
%time interval from –5*T to 5*T (p(t) is symmetrical respect to t=0).
clf
Rsym=1000; %bauds
Tsym=1/Rsym;
Fs = 5*Rsym; % Sampling frequency
t = -5*Tsym:1/Fs:5*Tsym; % Time vector (sampling intervals)
t = t+0.00000001; % Otherwise, the denominator would be zero at t=0
some_r = [0 0.5 1 2]; % Roll-off factors
clf
hold on
r = some_r(1);
p = (sin(pi*t/Tsym)./(pi*t/Tsym)).*(cos(r*pi*t/Tsym)./(1-(2*r*t/Tsym).^2));
plot(t,p,'b-')
r = some_r(2);
p = (sin(pi*t/Tsym)./(pi*t/Tsym)).*(cos(r*pi*t/Tsym)./(1-(2*r*t/Tsym).^2));
plot(t,p,'k:')
r = some_r(3);
p = (sin(pi*t/Tsym)./(pi*t/Tsym)).*(cos(r*pi*t/Tsym)./(1-(2*r*t/Tsym).^2));
plot(t,p,'ro-')
if 0 %take out r=2
    r = some_r(4);
    p = (sin(pi*t/Tsym)./(pi*t/Tsym)).*(cos(r*pi*t/Tsym)./(1-(2*r*t/Tsym).^2));
    plot(t,p,'k-.')
end
legend('r=0','r=0.5','r=1');
xlabel('time (s)');
ylabel('p(t)');
axis tight
grid
writeEPS('raisedCosineTimeDomain');


clf
variousR=[0 0.5 1 2];
N=1000; %grid
r=variousR(1);
Omega1 = pi/Tsym*(1-r);
Omega2 = pi/Tsym*(1+r);
omega = linspace(0,10*Rsym,N);
P = zeros(size(omega));
P = (Tsym/2)*(1-sin(Tsym/(2*r)*(abs(omega)-pi/Tsym)));
P(find(omega<Omega1)) = Tsym;
P(find(omega>Omega2)) = 0;
%plot(omega/2/pi, P/Tsym,'b-');
plot(omega/2/pi, P,'b-');
hold on
N=30; %decrease grid
r=variousR(2);
Omega1 = pi/Tsym*(1-r);
Omega2 = pi/Tsym*(1+r);
omega = linspace(0,10*Rsym,N);
P = zeros(size(omega));
P = (Tsym/2)*(1-sin(Tsym/(2*r)*(abs(omega)-pi/Tsym)));
P(find(omega<Omega1)) = Tsym;
P(find(omega>Omega2)) = 0;
%plot(omega/2/pi, P/Tsym,'k:');
plot(omega/2/pi, P,'k:');
r=variousR(3);
Omega1 = pi/Tsym*(1-r);
Omega2 = pi/Tsym*(1+r);
omega = linspace(0,10*Rsym,N);
P = zeros(size(omega));
P = (Tsym/2)*(1-sin(Tsym/(2*r)*(abs(omega)-pi/Tsym)));
P(find(omega<Omega1)) = Tsym;
P(find(omega>Omega2)) = 0;
%plot(omega/2/pi, P/Tsym,'ro-');
plot(omega/2/pi, P,'ro-');
if 0 %take out r=2
    r=variousR(4);
    Omega1 = pi/Tsym*(1-r);
    Omega2 = pi/Tsym*(1+r);
    omega = linspace(0,10*Rsym,N);
    P = zeros(size(omega));
    P = (Tsym/2)*(1-sin(Tsym/(2*r)*(abs(omega)-pi/Tsym)));
    P(find(omega<Omega1)) = Tsym;
    P(find(omega>Omega2)) = 0;
    %plot(omega/2/pi, P/Tsym,'k-.');
    plot(omega/2/pi, P,'k-.');
end
legend('r=0','r=0.5','r=1');
axis tight
grid
xlabel('frequency (Hz)')
ylabel('P(f)');
writeEPS('raisedCosineFrequencyDomain');
