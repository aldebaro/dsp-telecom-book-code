%set global constants
global showPlots syncBits syncSymbols

showPlots=1; %use 1 to show plots

%synchronism bits
syncBits = [1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, ...
    1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, ...
    1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, ...
    0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 1];
%map synchronism bits to GMSK symbols
syncSymbols = T_SEQ_gen(syncBits);

rand('twister',0);
randn('state',0);
