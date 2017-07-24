function [ tx_burst , I , Q ] = gsm_mod_sb(Tb,OSR,BT,tx_data,SB_TRAINING)

% GSM_MOD:  This MatLab code generates a GSM synchronization burst (SB) by
%           combining tail, and training sequence bits with
%           two bloks of random data bits.
%           The burst sequence is differential encoded and then
%           subsequently GMSK modulated to provide oversampled
%           I and Q baseband representations.
%%
% INPUT:    Tb: Bit time, set by gsm_set.m
%          OSR: Oversampling ratio (fs/rb), set by gsm_set.m
%           BT: Bandwidth Bittime product, set by gsm_set.m
%      tx_data: The contents of the datafields in the burst to be
%               transmitted. Datafield one comes first.
%      TRAINING: The Training sequence which is to be inserted in the
%               burst.
%           
% OUTPUT:
%     tx_burst: The entire transmitted burst before differential
%               precoding.
% 	     I: Inphase part of modulated burst.
%            Q: Quadrature part of modulated burst.
%
% WARNINGS: No interleaving or channel coding is done, and thus the 
%           GSM recommadations are violated. Data simulations done using
%           this format can only be used for predicting Class II performance.
%
% AUTHOR:   Jan H. Mikkelsen / Arne Norre Ekstrøm
% EMAIL:    hmi@kom.auc.dk / aneks@kom.auc.dk
%
% $Id: gsm_mod.m,v 1.10 1997/12/17 15:29:27 aneks Exp $

% GENERATE BURST SEQUENCE (THIS IS ACTUALLY THE MUX).
TAIL = [0 0 0];

% COMBINE THE BURST BIT SEQUENCE
%
tx_burst = [TAIL tx_data(1:39) SB_TRAINING tx_data(40:78) TAIL];

% DIFFERENTIAL ENCODING.
%
burst = diff_enc(tx_burst);

% GMSK MODULATION OF BURST SEQUENCE
%
[I,Q] = gmsk_mod(burst,Tb,OSR,BT);
