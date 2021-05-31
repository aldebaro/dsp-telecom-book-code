g=[0.1 1e-10]; %channel squared magnitudes
deltaf = 4.13125e3; %subchannel BW (borrowed from ADSL standard)
N0 = 1e-17; %noise PSD in Watts/Hz, corresponding to -140 dBm/Hz
noisePowerPerTone = N0 * deltaf; %noise power at each tone
totalPower=1e-3; %total power (Watts) to be shared between tones
[powerPerTone,waterlevel,SNR]=ak_simplewaterfill(g,...
  noisePowerPerTone,totalPower) %solution provided by waterfilling
bitsPerTone = log2(1 + (powerPerTone.*g)/noisePowerPerTone) %bits
