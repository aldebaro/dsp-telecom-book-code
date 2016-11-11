hbs=30; %effective base station antenna height [m]
hms=1.5; %mobile station antenna height [m]
freq=900; %frequency [MHz]
category=1; %1: medium-sized city/suburban or 2: metropolitan area
Gtx=6; %transmitter antenna gain (dBi)
Grx=-2; %receiver antenna gain, negative due to body loss (dBi)
lossesTx=3; %total feeder cable + connector losses at Tx (dB)
margin=12; %link margin to combat fading, etc. (dB)
NFrx=6; %receiver noise figure (dB)
N0=-174 %thermal (or background) noise floor PSD value (dBm/Hz)
BW=25e3; %receiver equivalent noise bandwidth (Hz)
distance=1; %distance between antennas (reach)(km)
SNRmin=18; %minimum SNR for proper operation at AFE output (dB)
%% Calculations:
pathLoss=ak_pathLossCost231(hbs,hms,freq,distance,category); % (dB)
Pnoise_rx=N0+10*log10(BW); %noise power at receiver (dBm)
SNRin=SNRmin+NFrx; %SNR at the receiver AFE input (dB)
Prx=SNRin+Pnoise_rx %power of signal of interest at receiver (dBm)
requiredEIRP=Prx-Grx+pathLoss+margin; %minimum EIRP (dBm)
Ptx=requiredEIRP-Gtx+lossesTx; %obs: EIRP incorporated lossesTx (dBm)
disp(['COST-231: ' num2str(freq) ' MHz ==> Ptx = ' ...
    num2str(Ptx) ' dBm']) %shows minimum transmitter power