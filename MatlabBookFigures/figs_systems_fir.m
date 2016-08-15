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