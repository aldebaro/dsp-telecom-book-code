function tx_burst = burst_g(tx_data, TRAINING)
%
% burst_g:  This function generates a bit sequence representing 
%           a general GSM information burst. Included are tail 
%           and ctrl bits, data bits and a training sequence.
%
%           The GSM burst contains a total of 148 bits accounted
%           for in the following burststructure (GSM 05.05)
%
%           [ TAIL | DATA | CTRL | TRAINING | CTRL | DATA | TAIL ]
%           [  3   |  57  |  1   |    26    |  1   |  57  |  3   ]
%
%           [TAIL]    = [000]
%           [CTRL]    = [0] or [1] here [1]
%           [TRAINING] is passed to the function
%
% SYNTAX:   tx_burst = burst_g(tx_data, TRAINING)
%
% INPUT:    tx_data:  The burst data.
%           TRAINING: The Training sequence which is to be used.
%
% OUTPUT:   tx_burst: A complete 148 bits long GSM normal burst binary 
%                     sequence
%
% GLOBAL:   
% 					
% SUB_FUNC: None
%
% WARNINGS: None
%
% TEST(S):  Function tested  
%
% AUTHOR:   Jan H. Mikkelsen / Arne Norre Ekstrøm
% EMAIL:    hmi@kom.auc.dk / aneks@kom.auc.dk
%
% $Id: burst_g.m,v 1.6 1997/12/17 15:32:23 aneks Exp $

TAIL = [0 0 0];
CTRL = [1];

% COMBINE THE BURST BIT SEQUENCE
%
tx_burst = [TAIL tx_data(1:57) CTRL TRAINING CTRL tx_data(58:114) TAIL];