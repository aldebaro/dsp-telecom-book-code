clear all

%run the analysis of the GSMP challenge
%Need to cd to GSMsim folder:
cd ../Applications/GSMsim/ak_GSMsim/config
GSMsim_config  %set GSMtop variable

cd ../../../GSM_PHY_Analysis
gsm_setGlobalVariables
ak_step1a
ak_step1b
ak_step1c

ak_step2a

cd ../../MatlabBookFigures
writeEPS('gsm_usrp_synchronism'); %,'font12Only');

%ak_step2b %no need to run