hbs=53; %effective base station antenna height [m]
hms=1.5; %mobile station antenna height [m]
freq=2000; %frequency [MHz]
category=1; %1: medium-sized city/suburban or 2: metropolitan area
dist=linspace(1,20,30); %distance between antennas  [km]
cost231PathLossdB = ak_pathLossCost231(hbs,hms,freq,dist,category);
freeSpaceLossdB=32.45+20*log10(dist)+20*log10(freq);%in km and MHz
clf; plot(dist,cost231PathLossdB,'rx-',dist,freeSpaceLossdB,'bo-');
xlabel('distance (km)'); ylabel('Path loss (dB)'), 
legend('COST Hata','Free space','Location','SouthEast'), grid