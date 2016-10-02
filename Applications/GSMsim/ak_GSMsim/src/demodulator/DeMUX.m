function [ rx_data ] = DeMUX(rx_burst)

% DeMUX:   This pice of code does the demultiplexing of the received
%          GSM burst.
%
% SYNTAX:   [ rx_data ] = DeMUX(rx_burst)
%
% INPUT: ESTIMAE: An entire 148 bit GSM burst. The format is expected
%                 to be:
%
%           [ TAIL | DATA | CTRL | TRAINING | CTRL | DATA | TAIL ]
%           [  3   |  57  |  1   |    26    |  1   |  57  |  3   ]
%           
% OUTPUT:
%      rx_data: The contents of the datafields in the received burst.
%
% WARNINGS: None.
%
% AUTHOR:   Jan H. Mikkelsen / Arne Norre Ekstrøm
% EMAIL:    hmi@kom.auc.dk / aneks@kom.auc.dk
%
% $Id: DeMUX.m,v 1.3 1997/11/18 12:46:18 aneks Exp $

rx_data=[ rx_burst(4:60) , rx_burst(89:145) ];