%% Mimicking a continuous-time signal by using plot
Ts = 0.001; %sampling interval in seconds
t = -1.6:Ts:1.6; %discrete-time in seconds
pulse_width = 0.2; %support of this rect in seconds
x = rectpuls(t,pulse_width) - 3*rectpuls(t-0.2,pulse_width) + ...
    3*rectpuls(t-0.4,pulse_width); %define the signal
plot(t,x) %plot as a continuos-time signal
xlabel('t'), ylabel('x(t)')
