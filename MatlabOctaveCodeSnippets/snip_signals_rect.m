%% Mimicking a continuous-time signal by using plot
Ts = 0.001; %sampling interval in seconds
t = -0.8:Ts:0.8; %discrete-time in seconds
pulse_width = 0.2; %support of this rect in seconds
tc = 0.4; %center (in seconds) of this rect
A = 2.5; %amplitude (in Volts) of this rect
x = A*rectpuls(t-tc,pulse_width);
subplot(211), plot(t,x) %plot as a continuos-time signal
xlabel('t'), ylabel('x(t)')
%% Making explicit the signal is discrete-time by using stem
n = -10:10; %discrete-time in seconds
pulse_width = 5; %support of this rect in samples
nc = -3; %center (in samples) of this rect
A = 7; %amplitude (in Volts) of this rect
x = A*rectpuls(n-nc,pulse_width);
subplot(212), stem(n,x) %plot as a discrete-time signal
xlabel('n'), ylabel('x[n]')