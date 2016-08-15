clf
B_roots = [2*exp(j*pi/4) 2*exp(-j*pi/4) ... %define roots
    0.7*exp(j*pi/8) 0.7*exp(-j*pi/8)];
B=poly(B_roots) %construct B(z) of H(z)=B(z)/A(z)
A=poly([0.4 0.5 0.6 0.5j -0.5j 0.3j -0.3j]); %arbitrary
Bmin = ak_forceStableMinimumPhase(B) %move zeros inside
[H,w]=freqz(B,A); %frequency response for original H(z)
[Hmin,w]=freqz(Bmin,A); w=w/pi; %for minimum phase H(z)
subplot(211), plot(w,abs(H),w,abs(Hmin),'--'), axis tight
legend1 = legend('non-min','min-phase'), subplot(212)
set(legend1,'Position',[0.6274 0.6365 0.2339 0.1095]);
plot(w,unwrap(angle(H)),w,unwrap(angle(Hmin)),'--')
axis tight
xlabel('Normalized Frequency (\times \pi rad/sample)');
subplot(211), ylabel('Magnitude'), grid
myaxis = axis; myaxis(2)=1; axis(myaxis);
subplot(212), ylabel('Phase (rad)'), grid
myaxis = axis; myaxis(2)=1; axis(myaxis);
writeEPS('minphase_example')

%group delay
clf
[D,w]=grpdelay(B,A); %group delay for original H(z)
[Dmin,w]=grpdelay(Bmin,A); w=w/pi; %for minimum phase H(z)
%w = w/pi;
plot(w,D,w,Dmin,'--')
axis tight
xlabel('Normalized Frequency (\times \pi rad/sample)');
myaxis = axis; myaxis(2)=1; axis(myaxis);
ylabel('Group delay (samples)')
legend('non-min','min-phase'), grid
writeEPS('minphase_groupdelay')
