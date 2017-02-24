clf
f=[0 0.25 0.3 0.55 0.6 0.85 0.9 1]; %frequencies
A=[1 1 0 0 1 1 0 0]; %amplitudes
M=20; %filter order

weights=[1000 1 1 1];
B=firls(M,f,A,weights);
freqz(B)
hold on
subplot(211)
plot([f(1),f(2)],[0,0],'r')
plot([f(5),f(6)],[0,0],'r')
axis([0 1 -30 10])
writeEPS('fir_first_band_important')

clf
weights=[1 1 1000 1];
B=firls(M,f,A,weights);
freqz(B)
hold on
subplot(211)
plot([f(1),f(2)],[0,0],'r')
plot([f(5),f(6)],[0,0],'r')
axis([0 1 -30 10])
writeEPS('fir_second_band_important')

%Shows distinct symmetries
close all
snip_systems_FIR_types
subplot(421);
stem(0:length(hI)-1,hI);
ylabel('Type I')
title('h[n]')
subplot(422);
[H,w]=freqz(hI);
w=w/pi;
h=plotyy(w,20*log10(abs(H)),w,unwrap(angle(H))), ylabel(h(1),'mag (dB)'), ylabel(h(2),'phase (rad)');
title('H(e^{j \Omega})')
subplot(423);
stem(0:length(hII)-1,hII);
ylabel('Type II')
subplot(424);
H=freqz(hII);
plotyy(w,20*log10(abs(H)),w,unwrap(angle(H))); 
subplot(425);
stem(0:length(hIII)-1,hIII);
ylabel('Type III')
subplot(426);
H=freqz(hIII);
plotyy(w,20*log10(abs(H)),w,unwrap(angle(H))); 
subplot(427);
stem(0:length(hIV)-1,hIV);
ylabel('Type IV')
xlabel('n')
subplot(428);
H=freqz(hIV);
plotyy(w,20*log10(abs(H)),w,unwrap(angle(H))); 
xlabel('normalized \Omega / \pi')
writeEPS('fir_symmetries')
%writeEPS('fir_symmetries','font12Only')