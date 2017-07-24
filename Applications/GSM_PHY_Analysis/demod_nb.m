function [rx_burst] = demod_nb(r,start)
%demodulate a normal burst. Use ak_mafi for matched
%filtering

%defined in gsm_setGlobalVariables.m
global showPlots 

OSR = 4; %oversampling
Lh = 4; %the assumed channel dispersion. It will determine
%the length of the impulse response estimated by ak_mafi

a = conj(r(start:start+150*OSR-1));

%Training sequence with 26 bits used in normal bursts
%The 8 training sequences used in normal bursts:
TRAINING = [0 0 1 0 0 1 0 1 1 1 0 0 0 0 1 0 0 0 1 0 0 1 0 1 1 1];
%TRAINING = [0,0,1,0,1,1,0,1,1,1,0,1,1,1,1,0,0,0,1,0,1,1,0,1,1,1]
%TRAINING = [0,1,0,0,0,0,1,1,1,0,1,1,1,0,1,0,0,1,0,0,0,0,1,1,1,0];
%TRAINING = [0,1,0,0,0,1,1,1,1,0,1,1,0,1,0,0,0,1,0,0,0,1,1,1,1,0]
%TRAINING = [0,0,0,1,1,0,1,0,1,1,1,0,0,1,0,0,0,0,0,1,1,0,1,0,1,1]
%TRAINING = [0,1,0,0,1,1,1,0,1,0,1,1,0,0,0,0,0,1,0,0,1,1,1,0,1,0]
%TRAINING = [1,0,1,0,0,1,1,1,1,1,0,1,1,0,0,0,1,0,1,0,0,1,1,1,1,1]
%TRAINING = [1,1,1,0,1,1,1,1,0,0,0,1,0,0,1,0,1,1,1,0,1,1,1,1,0,0]

T_SEQ = T_SEQ_gen(TRAINING);

[ SYMBOLS , PREVIOUS , NEXT , START , STOPS ] = viterbi_init(Lh);

[Y, Rhh] = ak_mafi(a,Lh,T_SEQ,OSR);

if showPlots == 1
    plotframe2(Y)
    disp('NB. Press <ENTER>')
    pause
end

%rx_burst has the hard-decoded 0 or 1 bits
rx_burst = viterbi_detector(SYMBOLS,NEXT,PREVIOUS,START,STOPS,Y,Rhh);
