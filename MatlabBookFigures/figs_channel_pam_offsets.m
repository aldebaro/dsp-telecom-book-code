%Figures for FFT-based PAM carrier recovery
ex_fftBasedPAMCarrierRecovery %run script that generates signals
close all
[S,f]=ak_psd(sbb,Fs); 
h=plot(f/1e6,S); grid
index=find((abs(f-8e6)<1e4),1,'last');
position=[f(index)/1e6,S(index)];
ak_makedatatip(h,position)
myaxis=[-15 15 -130 -60];
axis(myaxis);
xlabel('f (MHz)'); ylabel('PSD S(f) (dBm/Hz)');
title('Baseband PAM');
writeEPS('fftBasedCarrierRecovery','font12Only');

[S,f]=ak_psd(s,Fs); 
h=plot(f/1e6,S); grid
%position=[-1e3 -70];
%ak_makedatatip(h,position)
myaxis=[-2000 2000 -160 -60];
axis(myaxis);
xlabel('f (MHz)'); ylabel('PSD S(f) (dBm/Hz)');
title('Upconverted PAM (carrier=1 GHz)');
writeEPS('pamOffsetsUpconverted','font12Only');

[S,f]=ak_psd(r,Fs); 
subplot(211)
h=plot(f/1e6,S); grid
%position=[-1e3 -70];
%ak_makedatatip(h,position)
myaxis=[-4000 4000 -160 -60];
axis(myaxis);
ylabel('PSD S(f) (dBm/Hz)');
title('PAM downconverted to IF=130 MHz');
subplot(212)
h=plot(f/1e6,S); grid
myaxis=[110 150 -160 -60];
axis(myaxis);
xlabel('f (MHz)'); ylabel('PSD S(f) (dBm/Hz)');
writeEPS('pamOffsetsAtIF','font12Only');

clf
[S,f]=ak_psd(r_carrierRecovery,Fs); 
h=plot(f/1e6,S); grid
position=[260 -74];
ak_makedatatip(h,position)
myaxis=[-Fs/2/1e6 Fs/2/1e6 -200 -60];
axis(myaxis);
xlabel('f (MHz)'); ylabel('PSD S(f) (dBm/Hz)');
title('Squared received PAM');
writeEPS('pamOffsetsSquaredRx','font12Only');

clf %plot R in the region of interest
range = minIndexOfInterestInFFT:maxIndexOfInterestInFFT;
plot((range-1)*resolutionHz/1e6,20*log(abs(R(range))))
axis tight
xlabel('f (MHz)'); ylabel('20 log(|R|)');
writeEPS('pamOffsetsZoomOfR','font12Only');

clf
[S,f]=ak_psd(r,Fs); 
h=plot(f/1e6,S); grid
hold on
[S,f]=ak_psd(rc,Fs); 
h=plot(f/1e6,S,'r'); grid
myaxis=[-3e3 3e3 -160 -60];
axis(myaxis);
xlabel('f (MHz)'); ylabel('PSD S(f) (dBm/Hz)');
title('PSDs of received signal and its complex-valued version after offset correction');
legend('received r','corrected rc','Location','SouthEast')
writeEPS('pamOffsetsShiftedPSDs','font12Only');

clf
subplot(211)
[S,f]=ak_psd(rc2,Fs); 
h=plot(f/1e6,S); grid
myaxis=[-3e3 3e3 -160 -60];
axis(myaxis);
xlabel('f (MHz)'); ylabel('PSD S(f) (dBm/Hz)');
title('PSD of real-valued rc2 signal');
subplot(212)
[S,f]=ak_psd(rf,Fs); 
h=plot(f/1e6,S); grid
myaxis=[-20 20 -100 -20];
axis(myaxis);
xlabel('f (MHz)'); ylabel('PSD S(f) (dBm/Hz)');
title('PSD of filtered rf signal');
writeEPS('pamOffsetsFilteredRx','font12Only');

clf
plot(real(constellation),imag(constellation),'rx','MarkerSize',20); 
hold on
plot(real(symbolsRx ),imag(symbolsRx),'o')
legend('Constellation','Rx symbols');
writeEPS('pamOffsetsConstellations','font12Only');

clear all