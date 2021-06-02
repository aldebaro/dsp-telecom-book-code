%AK I will cd and go back continuously because I am lazy to check
%when the scripts need the files within the steps.
%run it from Code\MatlabBookFigures
clear all
close all
clf
%add path to GSM scripts
P=path;
path(P,'../Applications/GSM_PHY_Analysis');

ex_gsm_freq_correction

subplot(131)
plot(n,real(x)) %plot to note that FB is a pure sine
axis tight, title('a)')
subplot(132)
plot(real(sq),imag(sq),'x') %received constellation
axis equal, title('b)')
subplot(133)
plot(real(sq_corrected),imag(sq_corrected ),'x')%corrected
axis equal, title('c)')

writeEPS('gsm_freq_correction')

%Need to cd to GSMsim folder:
cd ../Applications/GSMsim/ak_GSMsim/config
GSMsim_config  %set GSMtop variable

cd ../../../GSM_PHY_Analysis
%run the analysis of the GSMP challenge
gsm_setGlobalVariables
global showPlots 
showPlots = 1;
ak_step1a
cd ../../MatlabBookFigures
writeEPS('gsm_usrp_psds');

cd ../Applications/GSM_PHY_Analysis
ak_step1b
cd ../../MatlabBookFigures
writeEPS('gsm_usrp_bcch_location','font12Only');

cd ../Applications/GSM_PHY_Analysis
ak_step1c
cd ../../MatlabBookFigures
writeEPS('gsm_usrp_freq_offset'); %,'font12Only');

