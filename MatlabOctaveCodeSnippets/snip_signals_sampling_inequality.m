Fs=20; Ts=1/Fs; %sampling frequency Fs in Hz and period Ts in sec.
f0=Fs/2; %key thing: Fs should  be greater than 2 f0
t=0:Ts:1; %discrete-time axis, from 0 to 1 second
theta1=pi/4 %define an arbitrary angle
A1=1/cos(theta1); %amplitude
x1=A1*cos(2*pi*f0*t+theta1); %not obeying sampling theorem
theta2=0 %define any value distinct from theta1
A2=1/cos(theta2); %amplitude
x2=A2*cos(2*pi*f0*t+theta2); %not obeying sampling theorem
plot(t,x1,'rx',t,x2,'o-b'); title('Cannot distinguish 2 signals!')