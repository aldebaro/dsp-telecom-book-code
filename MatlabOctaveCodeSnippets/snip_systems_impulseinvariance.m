Ts=0.5; %sampling period
Bs=4; As=poly([-2 -3]); % Define H(s)=Bs/As
[Bz,Az] = impinvar(Bs,As,1/Ts);%impulse invariance conversion to H(z)
t=0:Ts:10; ht=4*(exp(-2*t)-exp(-3*t)); %create h(t) to compare
hn=impz(Bz,Az,length(ht)); %discrete-time h[n] from H(z)=Bz/Az
h_Error=Ts*ht(:) - hn(:); %error from column vectors
disp(['mean square error (MSE) = ' num2str(mean(h_Error.^2))]);
plot(t,Ts*ht); hold on; plot(t,hn,'rx'); %compare curves
legend('T_s \times h(t)','h(nT_s) that has same amplitudes of h[n]')
xlabel('time (s)')
ak_increaseFigureItems