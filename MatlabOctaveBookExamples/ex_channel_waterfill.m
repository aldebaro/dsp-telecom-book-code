%illustrates water filling
clear all, close all
N0 = 1e-17;  %-140 dBm/Hz, unilateral noise PSD in W/Hz
deltaF = 1e3; %subchannel BW in Hz
totalPower = 5e-13; %total power to be allocated
noisePowerPerTone = N0*deltaF; %noise power (in W) per tone
g = [1 1e-1 1.1 4e-2 5e-2 1.2 1e-1]; %channel squared magnitudes
[powerPerTone,powerWaterlevel,SNR]=ak_simplewaterfill(g,noisePowerPerTone,totalPower);
psdWaterlevel = powerWaterlevel / deltaF;
psdPerTone = powerPerTone/deltaF;
disp(['Optimum power per tone:' num2str(powerPerTone)]);
disp(['Optimum PSD:' num2str(psdPerTone)]);
%sanity check
disp(['Power should be the same: ' num2str(sum(powerPerTone)) ' and ' num2str(totalPower)])
disp(['Power water level = ' num2str(powerWaterlevel)]);
disp(['PSD water level = ' num2str(psdWaterlevel)]);
disp(['N_0./g = ' num2str(N0./g)])
%plot figure in linear scale
A=[(N0./g); psdPerTone];
clf, bar(A','stacked')
xlabel('Tones (k)')
ylabel('Stacked: N_0/g  and  PSDs')
hold on
plot(1:length(powerPerTone),psdWaterlevel*ones(size(powerPerTone)),'-x','markersize',16);
legend1 = legend('Inverse "SNR": N_0/g','Transmit PSD');
bitsPerTone = log2(1+SNR);
disp(['bitsPerTone  = ' num2str(bitsPerTone)])
total_number_of_bits = sum(bitsPerTone);
disp(['total_number_of_bits = ' num2str(total_number_of_bits)])
