W=linspace(0,3*pi/4,100); %frequencies in rad
Fs=0.5; %sampling frequency. Use a convenient value.
w=2*Fs*tan(W/2); %warped frequencies in rad/s
deltaw=pi/8; WinRad=[pi/16+(1:6)*deltaw] %some sensible values
wInRadperS=2*Fs*tan(WinRad/2) %convert using the bilinear warping
plot(W,w), xlabel('\Omega (rad)'), ylabel('\omega (rad/s)')
disp(['B1=' num2str(WinRad(2)-WinRad(1)) ' and B3=' ...
    num2str(WinRad(6)-WinRad(5)) ' rad, while b1=' ...
    num2str(wInRadperS(2)-wInRadperS(1)) ' and b3=' ...
    num2str(wInRadperS(6)-wInRadperS(5)) ' rad/s'])