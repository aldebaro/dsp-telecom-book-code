%% Run scripts for GSM signal analysis
clear * %clear all variables but breakpoints
gsm_setGlobalVariables %set some global variables
ak_step1a %choose the file, read its corresponding signal and filter it
ak_step1b %find the start of frequency correction bursts
ak_step1c %estimate the frequency offset and correct it
ak_step2a %from FCCHs, find the start of their companion SCHs
ak_step2b %decode all SCH bursts to get frame number, etc.
ak_step3  %decode the BCCH and CCCH that follow each SCH