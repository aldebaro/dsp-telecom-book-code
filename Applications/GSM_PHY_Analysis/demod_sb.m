function [BCC, PLM, FN, rx_burst] = demod_sb(r,start)
%demodulate a synchronism burst. Use ak_mafi_sch for 
%matched filtering and Viterbi decoding
%Format of SB:
%3 tail bits | 39 data | 64 sync | 39 data | 3 tail | 8.25 guard
%defined in gsm_setGlobalVariables.m
%syncSymbols  is the 64-symbols training sequence used in SB
global syncSymbols showPlots Lh

OSR = 4; %oversampling

a = conj(r(start:start+150*OSR-1)); %do not include the guard period

%eyediagram(real(a(2:end)),OSR)
%plot(real(a(2:OSR:end)),imag(a(2:OSR:end)),'x')

%the SCH burst has a longer training sequence than the
%used in normal bursts:
%TRAINING = [1 0 1 1 1 0 0 1 0 1 1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 1 1 1 1 0 0 1 0 1 1 0 1 0 1 0 0 0 1 0 1 0 1 1 1 0 1 1 0 0 0 0 1 1 0 1 1];                                
%T_SEQ = T_SEQ_gen(TRAINING);

[ SYMBOLS , PREVIOUS , NEXT , START , STOPS ] = viterbi_init(Lh);

%[Y, Rhh] = ak_mafi_sch(a,Lh,T_SEQ,OSR);
[Y, Rhh] = ak_mafi_sch(a,Lh,syncSymbols,OSR);

%showPlots=1;
if showPlots==1
    plotframe2(Y)
    disp('SB. Press <ENTER>')
    pause
end

% Adjust phase according to detector requirements
% Phase is wrong because MAFI_SCH was created from MAFI
% and expanded for a longer sequence
Y = Y*-1i;

rx_burst = viterbi_detector(SYMBOLS,NEXT,PREVIOUS,START,STOPS,Y,Rhh);

%The two blocks of 39 bits each
DATABITS1 = rx_burst(4:42); %skip 3 tail bits in front
DATABITS2 = rx_burst(107:145); %skip 3 tail + 39 data + 64 sync = 106

%rx_block has 25 bits
[rx_block,FLAG_SS,PARITY_CHK] = channel_dec_sch([DATABITS1 DATABITS2]);

BSIC = rx_block(3:8); %6 bits to identify BTS (BSIC)
%19 bits are used to identify the frame number (FN) as follows:
%=> 11 bits identify the superframe within the hyperframe (1 hyperframe = 2048 superframes)
%=> 5 bits specify the multiframe within the superframe (1 superframe = 26 control multiframes)
%=> 3 bits identify the control block within the control multiframe (1 control multiframe = 5 control blocks)
T1   = [ rx_block(24) rx_block(9:16) rx_block(1:2)] * [1 2 4 8 16 32 64 128 256 512 1024]';
T2   = rx_block(19:23) * [1 2 4 8 16]';
T3M   = [ rx_block(25) rx_block(17:18)] * [1 2 4]';

BCC = BSIC(1:3) * [1 2 4]';
PLM = BSIC(4:6) * [1 2 4]';
FN = frame_nr(T3M, T2, T1);
