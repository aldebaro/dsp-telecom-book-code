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
rng('default')
rng(0)
%rand('twister',0); %deprecated
%randn('state',0);

%turn warning on when using Matlab (sometimes it is off)
%w = warning ('on','all');

global debugWithArtificialFile 
showPlots=0; %use 1 to show plots
% Select the file to analyze
fileNumber=8; %there are 9 files. Choose a number between 1 and 9
%Obs: file 1 does not have a FCCH. Use 8 for testing and 6 for long
%duration signal. File 4 changes the BCC and PLM in some bursts. File
%9 (called beacon.cfile) should be first artificially generated with 
%script ak_CreateC0T0BeaconSignal. File 7 has several correct checksums.

% Gets the data from a file:
%Select a folder and end it with slash (/ or \). For example:
%folder='C:/gits/Latex/ak_dspbook/Code/Applications/GSM_PHY_Analysis/';
%folder='C:/ak/Classes/Pos_PDSemFPGAeDSP/Projetos1aSemana/GSM_analysis/RawFiles/';
folder='./GSMSignalFiles/'; %default folder using relative path
if fileNumber==9
    debugWithArtificialFile = 1;
else 
    debugWithArtificialFile = 0;
    %error('Wrong configuration of fileNumber and debugWithArtificialFile');
end
