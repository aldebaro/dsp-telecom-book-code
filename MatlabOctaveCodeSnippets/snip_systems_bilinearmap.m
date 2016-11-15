%% Plot the bilinear frequency relation
Fs=0.5; %sampling frequency. Use a convenient value.
W=linspace(0,3*pi/4,100); %digital frequencies in rad
w=2*Fs*tan(W/2); %analog (warped) frequencies in rad/s
plot(W,w), xlabel('\Omega (rad)'), ylabel('\omega (rad/s)')
%% Same bandwidths in w (rad/s) lead to decreasing bands in W (rad)
deltaw=0.4; w=[0.2+(1:6)*deltaw]; %frequencies in w (rad/s)
disp(['b1,b2,b3=' num2str(deltaw) ' rad/s (all have same value)'])
W=2*atan(w/(2*Fs)); %find the corresponding frequencies in W (rad)
disp(['B1,B2,B3=' num2str(W(2)-W(1)) ', ' num2str(W(4)-W(3)) ', ' ...
    num2str(W(6)-W(5)) ' rad, respectively']);