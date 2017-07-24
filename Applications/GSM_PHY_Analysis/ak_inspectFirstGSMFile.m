%AK: The first file does not have FCCH and I assumed it was a 26 frames
%multiframe, and tried to crosscorrelate with training sequence of
%normal burst but it did not work
clear * %clear all variables but breakpoints
close all
gsm_setGlobalVariables %set some global variables
ak_step1a %make sure you chose the first file here

[Interpolation,Decimation]=rat(SymbolRate/SampleRate);
t = resample(r,Interpolation,Decimation); %t is at symbol rate

%Training sequence with 26 bits used in normal bursts
%The 8 training sequences used in normal bursts:
TRAINING = [0 0 1 0 0 1 0 1 1 1 0 0 0 0 1 0 0 0 1 0 0 1 0 1 1 1];
T_SEQ = T_SEQ_gen(TRAINING);
%T_SEQ = T_SEQ(6:21); 

figure(2)
[Rxy,lags]=xcorr(t,T_SEQ);
plot(lags,Rxy)