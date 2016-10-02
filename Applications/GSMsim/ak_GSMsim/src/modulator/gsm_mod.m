function [ tx_burst , I , Q ] = gsm_mod(Tb,OSR,BT,tx_data,TRAINING)

% GSM_MOD:  This MatLab code generates a GSM normal burst by
%           combining tail, ctrl, and training sequence bits with
%           two bloks of random data bits.
%           The data bits are convolutional encoded according
%           to the GSM recommendations
%           The burst sequence is differential encoded and then
%           subsequently GMSK modulated to provide oversampled
%           I and Q baseband representations.
%
% SYNTAX:   [ tx_burst , I , Q ] = gsm_mod(Tb,OSR,BT,tx_data,TRAINING)
%
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
%
tx_burst = burst_g(tx_data,TRAINING);

% DIFFERENTIAL ENCODING.
%
burst = diff_enc(tx_burst);

% GMSK MODULATION OF BURST SEQUENCE
%
[I,Q] = gmsk_mod(burst,Tb,OSR,BT);
