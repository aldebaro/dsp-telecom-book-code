function [tx_data] = data_gen(INIT_L);
%
% data_gen:   This function generates a block of random data bits. 
%
% SYNTAX:     [tx_data] = data_gen(INIT_L)
%
% INPUT:      INIT_L:  The length of the generated data vector.
%
% OUTPUT:     tx_data: An element vector contaning the random data 
%                      sequence of length INIT_L. INIT_L is a variable 
%                      set by gsm_set.
%
% SUB_FUNC:   None
%
% WARNINGS:   None
%
% TEST(S):    Function tested.
%
% AUTOR:      Arne Norre Ekstrøm / Jan H. Mikkelsen
% EMAIL:      aneks@kom.auc.dk / hmi@kom.auc.dk
%
% $Id: data_gen.m,v 1.6 1997/09/22 11:46:29 aneks Exp $ 
%

% GENERATE init_l RANDOM BITS. FUNCTION IS BASED ON THAT RAND RETURNS 
% UNIFORMLY DISTRIBUTED DATA IN THE INTERVAL [ 0.0 ; 1.0 ].
%
tx_data = round(rand(1,INIT_L));