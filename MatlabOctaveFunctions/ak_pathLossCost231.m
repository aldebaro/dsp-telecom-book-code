function pathLossdB = ak_pathLossCost231(hbs,hms,freq,dist,category)
% function pathLossdB=ak_cost231model(hbs, hms, freq, dist, category)
%COST231Hata - returns signal attenuation based on COST231-Hata Model
%      pathLossdB - radio signal attenuation [dB]
%      hbs - effective base station antenna height [m]
%           30 <= hbs <= 200 m
%      hms - mobile station antenna height [m]
%           1 <= hms <= 10 m
%      freq - frequency [MHz]
%           1500 <= freq <= 2000 MHz
%      dist - distance between antennas  [km]
%           1 <= dis <= 20 km
%      category - category type: {1, 2}
%           1 - medium-sized city and suburban, 2 - metropolitan area
%   Based on code by Michal Bok, PWr 2008
if((min(freq)<1500)||(max(freq)>2000))
    warning('required frequency = 1500 <= f <= 2000 MHz');
end
if((min(hbs)<30)||(max(hbs)>200))
    warning('Base station antenna height = 30 <= hbs <= 200 m');
end
if((min(hms)<1)||(max(hms)>10))
    warning('Mobile station antenna height must be 1 <= hms <= 10 m');
end
if((min(dist)<1)||(max(dist)>20))
    warning('Required distance between antennas = 1 <= d <= 20 km');
end
if((category~=1) && (category~=2))
    error('Required category is 1 or 2');
end
%value that depends on hms and frequency:
a_hms_f = (1.1 * log10(freq) - 0.7) * hms - (1.56 * log10(freq)-0.8);
if(category==1)
    C = 0;
elseif(category==2)
    C = 3;
end
pathLossdB = 46.3 + 33.9 * log10(freq) - 13.82 * log10(hbs) - ...
    a_hms_f + (44.9 - 6.55 * log10(hbs)) * log10(dist) + C;