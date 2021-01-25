%% Generate time-domain signal
Ts=0.0001; %defines resolution in time
t=0:Ts:30; %time axis
a=0.9; %constant
x=exp(-a*t); %signal
subplot(211), plot(t,x)
xlabel('t (s)'); ylabel('x(t) amplitude')
%% Generate ESD
f=linspace(-2,2,1000); %frequency axis
Gf= 1 ./ ((2*pi*f).^2 + a^2); %ESD
subplot(212)
plot(t,x), plot(f,Gf)
xlabel('f (Hz)'); ylabel('ESD (J/Hz)')
%% Confirm Parseval theorem
energy_equation = 1/(2*a); %theoretical
energy_time = sum(abs(x).^2)*Ts; %integration
df=0.0001; %defines resolution in frequency
min_f = -1000; %range of interest
max_f = 1000;
f=min_f:df:max_f; %frequency axis
Gf= 1 ./ ((2*pi*f).^2 + a^2); %recalculate ESD
energy_frequency = sum(Gf)*df; %integration
disp(['Theoretical energy =' num2str(energy_equation) ' Joules'])
disp(['Integration in time =' num2str(energy_time) ' Joules'])
disp(['Integration in frequency =' num2str(energy_frequency) ' J'])
%% Energy in given frequency band
min_f = 0.2; max_f = 1; %range of interest
f=min_f:df:max_f; %new frequency axis
Gf= 1 ./ ((2*pi*f).^2 + a^2); %recalculate ESD
energy_band = 2*sum(Gf)*df; %integration using 2 times
disp(['Energy in band =' num2str(energy_band) ' Joules'])