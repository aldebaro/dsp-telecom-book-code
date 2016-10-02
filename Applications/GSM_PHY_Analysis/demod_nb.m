function [rx_burst] = demod_nb(r,start)
%demodulate a normal burst. Use ak_mafi for matched
%filtering

OSR = 4;
Lh = 4; %the assumed channel dispersion. It will determine
%the length of the impulse response estimated by ak_mafi

a = conj(r(start:start+150*OSR-1));

%The 8 training sequences used in normal bursts
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

rx_burst = viterbi_detector(SYMBOLS,NEXT,PREVIOUS,START,STOPS,Y,Rhh);

