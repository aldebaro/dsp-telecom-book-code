c=299792458; %speed of light, approximately 3e8 (meters/second)
frequencies=[900 1800 2100 2500]; %frequencies of interest (MHz)
Prx=-102; %standardized receiver sensitivity for GSM (dBm)
EIRP=40.8; %transmitter equivalent isotropically radiated power (dBm)
Grx=-3; %receiver antenna gain (dBi)
Lcables=4; %total feeder cable loss, considering both Tx and Rx (dB)
Loss=EIRP+Grx-Prx-Lcables; %maximum allowed path loss (dB)
Loss_linear=10^(0.1*Loss); %convert from dB to linear scale
hbs=53; %effective base station antenna height [m]
hms=1.5; %mobile station antenna height [m]
category=1; %1: medium-sized city/suburban or 2: metropolitan area
for i=1:4
    f=frequencies(i); %choose a frequency
    d_fs=sqrt(Loss_linear)*c/(4*pi*f*1e6); %find the maximum distance
    d_cost=ak_distanceCost231(hbs, hms, f, Loss, category); %COST
    disp([num2str(f) ' MHz, FS=' num2str(d_fs/1e3) ' and COST=' ...
        num2str(d_cost/1e3) ' km']) %shows both distances
end