%illustrates water filling
clear all, close all
N0 = 1e-17;  %-140 dBm/Hz, unilateral noise PSD
deltaF = 1e3; %subchannel BW in Hz
totalPower = 5e-13; %total power to be allocated
maxPowerNormalized = totalPower/deltaF; %power normalized by BW
g = [1 1e-1 1.1 4e-2 5e-2 1.2 1e-1] %channel squared magnitudes
[S,waterlevel,SNR]=ak_simplewaterfill(g,N0,maxPowerNormalized);
disp(['Optimum PSD:']);
S
%sanity check
disp(['Should be the same: ' num2str(sum(S)) ' and ' num2str(maxPowerNormalized)])
disp(['Waterlevel = ' num2str(waterlevel)]);
disp(['sigma./g = '])
(N0./g)
%plot figure in linear scale
A=[(N0./g); S];
clf, bar(A','stacked')
xlabel('Tones (k)')
ylabel('Stacked: N_0/g  and  PSDs')
hold on
plot(1:length(S),waterlevel*ones(size(S)),'-X','markersize',16);
legend1 = legend('Inverse "SNR": N_0/g','PSD')
writeEPS('waterfill','font12Only');
hold off
bitsPerTone = log2(1+SNR)
Rate = sum(bitsPerTone)