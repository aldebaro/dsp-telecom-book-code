%Illustrates the step invariance method to convert a single pole H(s)
Ts=0.5; %sampling period
a=10; %pole
Bs=a; As=[1 a]; % Define H(s)=Bs/As
%Note below the delay z^{-1} in Bz to align u[n] with u(t).
%Try using Bz=[1-exp(-a*Ts)] instead.
Bz=[0 1-exp(-a*Ts)]; %get theoretical B(z). 
Az=[1-exp(-a*Ts)]; %get theoretical A(z)
t=0:Ts:10; qt=1-exp(-a*t); %q(t) is the system response to u(t)
un=ones(1,2*length(t));
hn=impz(Bz,Az,length(ht)); %discrete-time h[n] from H(z)=Bz/Az
qn=conv(un,hn);
q_Error=qt - qn(1:length(qt)); %error from column vectors
disp(['mean square error (MSE) = ' num2str(mean(q_Error.^2))]);
plot(t,qt); hold on; plot(t,qn(1:length(t)),'rx'); %compare curves
legend('q(t)','q[n]')
xlabel('time (s)')
ak_increaseFigureItems