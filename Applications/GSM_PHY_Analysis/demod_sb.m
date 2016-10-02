function [BCC, PLM, FN] = demod_sb(r,start)
%demodulate a synchronism burst. Use ak_mafi_sch for 
%matched filtering

OSR = 4;
Lh = 4; %the assumed channel dispersion. It will determine
%the length of the impulse response estimated by ak_mafi

a = conj(r(start:start+150*OSR-1));

%the SCH burst has a longer training sequence than the
%used in normal bursts:
TRAINING = [1 0 1 1 1 0 0 1 0 1 1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 1 1 1 1 0 0 1 0 1 1 0 1 0 1 0 0 0 1 0 1 0 1 1 1 0 1 1 0 0 0 0 1 1 0 1 1];
                                
T_SEQ = T_SEQ_gen(TRAINING);

[ SYMBOLS , PREVIOUS , NEXT , START , STOPS ] = viterbi_init(Lh);

[Y, Rhh] = ak_mafi_sch(a,Lh,T_SEQ,OSR);

% Adjust phase according to detector requirements
% Phase is wrong because MAFI_SCH was created from MAFI
% and expanded for a longer sequence
Y = Y*-i;

rx_burst = viterbi_detector(SYMBOLS,NEXT,PREVIOUS,START,STOPS,Y,Rhh);

DATABITS1 = rx_burst(4:42);
DATABITS2 = rx_burst(107:145);

[rx_block,FLAG_SS,PARITY_CHK] = channel_dec_sch([DATABITS1 DATABITS2]);

BSIC = rx_block(3:8);
T1   = [ rx_block(24) rx_block(9:16) rx_block(1:2)] * [1 2 4 8 16 32 64 128 256 512 1024]';
T2   = rx_block(19:23) * [1 2 4 8 16]';
T3M   = [ rx_block(25) rx_block(17:18)] * [1 2 4]';

T3 = (10 * T3M) + 1;
BCC = BSIC(1:3) * [1 2 4]';
PLM = BSIC(4:6) * [1 2 4]';
FN = frame_nr(T3M, T2, T1);
