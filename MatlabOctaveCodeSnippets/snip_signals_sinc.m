Ts = 0.001; %sampling interval (in seconds)
xi = 0.2; %support of the sinc in seconds
gamma = 0.5; %time shift
t = -1.6:Ts:1.6; %define discrete-time abscissa with fine resolution
x = 3*sinc((t-gamma)/xi); %define the signal x(t)
plot(t,x); 

