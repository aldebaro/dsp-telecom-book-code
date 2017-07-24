%% Run scripts for GSM signal analysis
clear * %clear all variables but breakpoints
gsm_setGlobalVariables %set some global variables
showPlots=0; %use 1 to show plots
% Select the file to analyze
fileNumber=4; %there are 8 files. Choose a number between 1 and 8
%Obs: file 1 does not have a FCCH. Use 8 for testing and 6 for long
%duration signal. File 4 changes the BCC and PLM in some bursts
% Gets the data from a file:
%Select a folder and end it with slash (/ or \). For example:
%folder='C:/gits/Latex/ak_dspbook/Code/Applications/GSM_PHY_Analysis/';
%folder='C:/ak/Classes/Pos_PDSemFPGAeDSP/Projetos1aSemana/GSM_analysis/RawFiles/';
folder='./GSMSignalFiles/'; %default folder using relative path

ak_step1a %choose the file, read its corresponding signal and filter it
ak_step1b %find the start of frequency correction bursts
ak_step1c %estimate the frequency offset and correct it
ak_step2a %from FCCHs, find the start of their companion SCHs
ak_step2b %decode all SCH bursts to get frame number, etc.
ak_step3  %decode the BCCH and CCCH that follow each SCH