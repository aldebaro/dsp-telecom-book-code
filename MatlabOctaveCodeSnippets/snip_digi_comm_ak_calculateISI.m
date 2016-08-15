p=[2 1 3 0 3]; %shaping pulse
symbols=[3 -1 3 1]; %symbols used for all plots
L=2; %oversampling factor
N0=2; %sample to start obtaining the symbols
[isi,signalParcels] = ak_calculateISI(symbols, p, L, N0)

