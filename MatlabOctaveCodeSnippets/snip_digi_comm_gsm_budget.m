hbs=30; %effective base station antenna height [m]
hms=1.5; %mobile station antenna height [m]
freq=950; %frequency [MHz]
category=1; %1: medium-sized city/suburban or 2: metropolitan area
sensitivity=-102; %standardized receiver sensitivity for GSM (dBm)
Ptx=45; %transmitter power (dBm)
Gtx=10; %transmitter antenna gain (dBi)
Grx=-3; %receiver antenna gain (dBi)
losses=5; %total feeder cable + connector losses, both Tx and Rx (dB)
margin=12; %link margin (dB)
EIRP=Ptx+Gtx-losses; %EIRP incorporating losses (dBm)
minRxPower=sensitivity+margin-Grx; %minimum power at Rx (dBm)
admissibleLoss=EIRP-minRxPower %maximum allowed path loss (dB)
dist=ak_distanceCost231(hbs,hms,freq,admissibleLoss,category); % (m)
disp(['COST-231: ' num2str(freq) ' MHz => ' ...
        num2str(dist/1e3) ' km']) %shows distance
