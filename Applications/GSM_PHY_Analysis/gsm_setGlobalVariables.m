%set global constants
global showPlots syncBits syncSymbols Lh

if ~exist('GSMtop','var')
    error('You need to execute GSMsim_config while in GSM config folder')
end

showPlots=1; %use 1 to show plots

Lh = 4; %the assumed channel dispersion. It will determine
%the length of the impulse response estimated by ak_mafi, etc.
%possible values: [2, 4]

%synchronism bits used in the synchronization burst (SB)
syncBits = [1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, ...
    1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, ...
    1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, ...
    0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 1];
%map synchronism bits to GMSK symbols
syncSymbols = T_SEQ_gen(syncBits); %in SB

%initialize random number generators
rand('twister',0);
randn('state',0);

%turn warning on when using Matlab (sometimes it is off)
%w = warning ('on','all');