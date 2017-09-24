function [dlfreq,ulfreq]=ak_arfcnToFreqMHz(arfcn)
% function [dlfreq,ulfreq]=arfcnToFreqMHz(arfcn)
% Frequencies are in MHz
%From http://www.rfwireless-world.com/Terminology/GSM-ARFCN-to-frequency-conversion.html
%Form GSP-P, 900 MHz
ulfreq=890+0.2*arfcn;
dlfreq=ulfreq+45;
