%Figures for FFT-based QAM carrier recovery
%this is based on figures for FFT-based PAM carrier recovery
ex_fftBasedQAMCarrierRecovery %run script that generates signals
close all
[S,f]=ak_psd(sbb,Fs); 
h=plot(f/1e6,S); grid
index=find((abs(f-8e6)<1e5),1,'last');
position=[f(index)/1e6,S(index)];
ak_makedatatip(h,position)
myaxis=[-15 15 -130 -60];
axis(myaxis);
xlabel('f (MHz)'); ylabel('PSD S(f) (dBm/Hz)');
title('Baseband QAM');
%pause; 
%writeEPS('qamOffsetsBaseband','font12Only');

[S,f]=ak_psd(s,Fs); 
h=plot(f/1e6,S); grid
%position=[-1e3 -70];
%ak_makedatatip(h,position)
myaxis=[-2000 2000 -160 -60];
axis(myaxis);
xlabel('f (MHz)'); ylabel('PSD S(f) (dBm/Hz)');
title('Upconverted QAM (carrier=1 GHz)');
%pause; 
%writeEPS('qamOffsetsUpconverted','font12Only');

[S,f]=ak_psd(r,Fs); 
subplot(211)
h=plot(f/1e6,S); grid
%position=[-1e3 -70];
%ak_makedatatip(h,position)
myaxis=[-4000 4000 -160 -60];
axis(myaxis);
ylabel('PSD S(f) (dBm/Hz)');
title('QAM downconverted to IF=130 MHz');
subplot(212)
h=plot(f/1e6,S); grid
myaxis=[110 150 -160 -60];
axis(myaxis);
xlabel('f (MHz)'); ylabel('PSD S(f) (dBm/Hz)');
%pause; 
%writeEPS('qamOffsetsAtIF','font12Only');


clf %plot R in the region of interest
range = minIndexOfInterestInFFT:maxIndexOfInterestInFFT;
plot((range-1)*resolutionHz/1e6,20*log(abs(R(range))))
axis tight
xlabel('f (MHz)'); ylabel('20 log(|R|)');
%pause; 
%writeEPS('qamOffsetsZoomOfR','font12Only');

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
%pause; 
%writeEPS('qamOffsetsShiftedPSDs','font12Only');

clf
[S,f]=ak_psd(rf,Fs); 
h=plot(f/1e6,S); grid
myaxis=[-20 20 -100 -20];
axis(myaxis);
xlabel('f (MHz)'); ylabel('PSD S(f) (dBm/Hz)');
title('PSD of filtered rf signal');
%pause; 
%writeEPS('qamOffsetsFilteredRx','font12Only');

clf
plot(real(constellation),imag(constellation),'rx','MarkerSize',20); 
hold on
plot(real(symbolsRx ),imag(symbolsRx),'o')
title('Constellation: X, received symbols: o');
%pause; 
writeEPS('qamOffsetsConstellations','font12Only');

close all
[S,f]=ak_psd(r_carrierRecovery,Fs); 
factor=1e6;
h=plot(f/factor,S); grid
whereToPlace='left';
snip_channel_qam_squared_freqs
inds=zeros(size(fqam));
for i=1:length(fqam)
    inds(i)=find(f>=fqam(i),1,'first');
end
fqam=fqam/factor;
position=[0 -100]; ak_makedatatip(h,position,'right')
position=[fqam(1) -125]; ak_makedatatip(h,position,'right')
position=[fqam(2) S(inds(2))]; ak_makedatatip(h,position,'right')
position=[fqam(3) S(inds(3))]; ak_makedatatip(h,position,whereToPlace)
position=[fqam(5) S(inds(5))]; ak_makedatatip(h,position,whereToPlace)
position=[fqam(7) -127.4]; ak_makedatatip(h,position,whereToPlace)
%position=[2522 -136.5]; ak_makedatatip(h,position)
position=[fqam(9) S(inds(9))]; ak_makedatatip(h,position,'right')
position=[fqam(10) -131]; ak_makedatatip(h,position,whereToPlace)
position=[fqam(12) S(inds(12))]; ak_makedatatip(h,position,'southeast')

xlabel('f (MHz)'); ylabel('PSD S(f) (dBm/Hz)');
%title('Signal raised to 4th power');
%pause; 

myaxis=[-100 600 -220 -100];
axis(myaxis);
writeEPS('qamOffsetsTo4RxZoom1','font12Only');

myaxis=[1600 2600 -200 -100];
axis(myaxis);
writeEPS('qamOffsetsTo4RxZoom2','font12Only');

myaxis=[3900 4600 -200 -100];
axis(myaxis);
writeEPS('qamOffsetsTo4RxZoom3','font12Only');

myaxis=[6000 9000 -220 -110];
axis(myaxis);
writeEPS('qamOffsetsTo4RxZoom4','font12Only');


%re-do figure, but wider
close all
[S,f]=ak_psd(r_carrierRecovery,Fs); 
factor=1e6;
h=plot(f/factor,S); grid
xlabel('f (MHz)'); ylabel('PSD S(f) (dBm/Hz)');
%To make a figura wider:
myaxis=[0 Fs/2/factor -220 -100];
%set(h,'Xtick',round([f_DC fqam]/factor))
%set(h,'Xtick',round([f_DC fqam]/factor))
%set(h,'XtickLabel',['f0';'f1'])
axis(myaxis);
x=get(gcf, 'Position'); %get figure's position on screen
x(3)=floor(x(3)*2.8); %adjust the size making it "wider"
set(gcf, 'Position',x);



whereToPlace='left';
snip_channel_qam_squared_freqs
inds=zeros(size(fqam));
for i=1:length(fqam)
    inds(i)=find(f>=fqam(i),1,'first');
end
fqam=fqam/factor;
position=[0 -100]; ak_makedatatip(h,position,'right')
position=[fqam(1) -125]; ak_makedatatip(h,position,'right')
position=[fqam(2) S(inds(2))]; ak_makedatatip(h,position,'right')
position=[fqam(3) S(inds(3))]; ak_makedatatip(h,position,whereToPlace)
position=[fqam(5) S(inds(5))]; ak_makedatatip(h,position,whereToPlace)
position=[fqam(7) -127.4]; ak_makedatatip(h,position,whereToPlace)
%position=[2522 -136.5]; ak_makedatatip(h,position)
position=[fqam(9) S(inds(9))]; ak_makedatatip(h,position,'right')
position=[fqam(10) -131]; ak_makedatatip(h,position,whereToPlace)
position=[fqam(12) S(inds(12))]; ak_makedatatip(h,position,'southeast')

drawnow
%writeEPS('qamOffsetsTo4Rx','none');
writeEPS('qamOffsetsTo4Rx','font12Only');

%clear * %discard all variables