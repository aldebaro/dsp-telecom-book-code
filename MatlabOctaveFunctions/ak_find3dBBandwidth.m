function bw_indices=ak_find3dBBandwidth(psddB, tolerance)
% function bw_indices=ak_find3dBBandwidth(psddB,tolerance)

if nargin == 1
    tolerance = eps
end
reference = max(psddB) - 3.0103;
%we would like to use 
%bw_indices = find(psddB == reference);
%but the exact value may not be part of psd_dB, so
bw_indices = find( abs(psddB-reference) <= tolerance);

%it does not work well for sthocastic signals because PSD
%varies when estimated with pwelch

%should implement a binary seach and avoid having to
%specify the tolerance

function 