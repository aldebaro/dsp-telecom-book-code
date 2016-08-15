g=[0.1 1e-10]; %channel squared magnitudes
deltaf = 4.13125e3; %subchannel BW (borrowed from ADSL standard)
N0 = 1e-17; %noise PSD in Watts/Hz, corresponding to -140 dBm/Hz
noisePower = N0 * deltaf; %noise power at each tone
totalPower=1e-3; %total power (Watts) to be shared between two tones
[powerPerTone,waterlevel,SNR]=ak_simplewaterfill(g,noisePower,...
    totalPower) %solution provided by waterfilling