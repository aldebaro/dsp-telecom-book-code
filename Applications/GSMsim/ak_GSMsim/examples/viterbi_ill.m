% VITERBI_ILL:
%           This MatLab code tests the implemented
%           viterbi detector. 
%
% SYNTAX:   viterbi_ill
%
% INPUT:    None
%
% OUTPUT:   None
%
% GLOBAL:   None
%
% WARNINGS: None
% 
% AUTHOR:   Arne Norre Ekstrøm
% EMAIL:    aneks@kom.auc.dk
%
% $Id: viterbi_ill.m,v 1.6 1997/11/18 12:35:13 aneks Exp $

% FIRST CONSTRUCT h
h=[ 1 0 0 0 0];
hcf=conj(fliplr(h));
Lh=length(h)-1;
Rhh=xcorr(h);
Rhh=Rhh(Lh+1:2*Lh+1);

% gsm_set MUST BE RUN PRIOR TO ANY SIMULATIONS, SINCE IT DOES SETUP
% OF VALUES NEEDED FOR OPERATION OF THE PACKAGE.
%
gsm_set;

% PREPARE THE TABLES NEEDED BY THE VITERBI ALGORITHM.
%
[ SYMBOLS , PREVIOUS , NEXT , START , STOPS ] = viterbi_init(Lh);

% GET RANDOM DATA FOR A BURST
%
% data HAS THE LENGTH 
data = data_gen(INIT_L);

% THIS IS WHERE INTERLEAVING AND CHANNEL ENCODING IS DONE.
% NOTE: THIS IS DISABLED IN THIS VERSION.
%
% enc_data = chan_enc(data);
enc_data=data;

% INTERLEAVING NOT IMPLEMENTED. HENCE, JUST THE FIRST 2 * 57
% BITS OF ENC_DATA IS TRANSMITTED
%
d1 = enc_data(1:57);
d2 = enc_data(58:114);
tx_data=[ d1 d2 ];

% GENERATE BURST SEQUENCE
%
burst = burst_g(d1,d2,TRAINING);

% DIFFERENTIAL ENCODING
%
tx_burst = diff_enc(burst);

% DO MSK MAPPING OF tx_burst
%
% THIS IS A CHOICE, AND IT MAY BE WRONG!!!!!!
I(1)=-j;
for n=2:length(tx_burst)
  I(n)=j*tx_burst(n)*I(n-1);
end

% PASS THE MSK SYMBOLS TRUGH AN ARTIFICIAL CHANNEL, OF A TYPE h
%
Y=conv(conv(h,hcf),I);
Y=Y(Lh+1:length(Y)-Lh);

% HAVING PREPARED THE PRECALCULATABLE PART OF THE VITERBI
% ALGORITHM, IT IS CALLED PASSING THE OBTAINED INFORMATION ALONG WITH
% THE RECEIVED SIGNAL, AND THE ESTIMATED AUTOCORRELATION FUNCTION.
%
rx_burst = viterbi_detector(SYMBOLS,NEXT,PREVIOUS,START,STOPS,Y,Rhh);

bit_errors=sum(xor(burst,rx_burst))