%% Run scripts for GSM signal analysis
%clear * %clear all variables but breakpoints
if ~exist('GSMtop','var')
    error('You need to execute GSMsim_config while in GSM config folder')
end
gsm_set %set some global variables (from GSMsim package)
global debugWithArtificialFile 
debugWithArtificialFile = 0;
showPlots=0; %use 1 to show plots
% Select the file to analyze
fileNumber=6; %there are 9 files. Choose a number between 1 and 9
%Obs: file 1 does not have a FCCH. Use 8 for testing and 6 for long
%duration signal. File 4 changes the BCC and PLM in some bursts. File
%9 (called beacon.cfile) should be first artificially generated with 
%script ak_CreateC0T0BeaconSignal

% Gets the data from a file:
%Select a folder and end it with slash (/ or \). For example:
%folder='C:/gits/Latex/ak_dspbook/Code/Applications/GSM_PHY_Analysis/';
%folder='C:/ak/Classes/Pos_PDSemFPGAeDSP/Projetos1aSemana/GSM_analysis/RawFiles/';
folder='./GSMSignalFiles/'; %default folder using relative path
if fileNumber~=9 && debugWithArtificialFile == 1
    error('Wrong configuration of fileNumber and debugWithArtificialFile');
end

ak_step1a %choose the file, read its corresponding signal and filter it
ak_step1b %find the start of frequency correction bursts
ak_step1c %estimate the frequency offset and correct it
ak_step2a %from FCCHs, find the start of their companion SCHs
ak_step2b %decode all SCH bursts to get frame number, etc.
ak_step3  %decode the BCCH and CCCH that follow each SCH