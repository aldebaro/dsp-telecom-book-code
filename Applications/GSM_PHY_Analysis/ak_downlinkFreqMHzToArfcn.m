function arfcn=ak_downlinkFreqMHzToArfcn(dlfreq)
% function arfcn=ak_downlinkFreqMHzToArfcn(dlfreq)
% Frequencies are in MHz
%From http://www.rfwireless-world.com/Terminology/GSM-ARFCN-to-frequency-conversion.html
%Form GSP-P, 900 MHz
arfcn=(dlfreq-45-890)/0.2;
if arfcn-round(arfcn) > eps %check if arfcn is an integer value
    error('Input frequency is not valid for the assumed GSM')
end
arfcn=round(arfcn);