function [ tx_burst , I , Q ] = gsm_mod_fb(Tb,OSR,BT)

% GSM_MOD:  This MatLab code generates a GSM frequency burst (FB). 
%           The burst sequence is differential encoded and then
%           subsequently GMSK modulated to provide oversampled
%           I and Q baseband representations.
%
% INPUT:    Tb: Bit time, set by gsm_set.m
%          OSR: Oversampling ratio (fs/rb), set by gsm_set.m
%           BT: Bandwidth Bittime product, set by gsm_set.m
%           
% OUTPUT:
%     tx_burst: The entire transmitted burst before differential
%               precoding.
% 	     I: Inphase part of modulated burst.
%            Q: Quadrature part of modulated burst.
%
%
% GENERATE BURST SEQUENCE (THIS IS ACTUALLY THE MUX).
%           The GSM burst contains a total of 148 bits accounted
%           for in the following burststructure (GSM 05.05)
%
%           [ TAIL | DATA | CTRL | TRAINING | CTRL | DATA | TAIL ]
%           [  3   |  57  |  1   |    26    |  1   |  57  |  3   ]
%
%           [TAIL]    = [000]
TAIL = [0 0 0];
tx_burst = [TAIL zeros(1,142) TAIL];

% DIFFERENTIAL ENCODING.
%
burst = diff_enc(tx_burst);

% GMSK MODULATION OF BURST SEQUENCE
%AK: When oversampling is 4, this function returns I and Q with
%600 samples, which corresponds to 150 bits, not 148 bits for the
%burst. I think it deserves correction.
[I,Q] = gmsk_mod(burst,Tb,OSR,BT);
