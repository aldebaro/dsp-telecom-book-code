function [G_FUN, Q_FUN] = ph_g(Tb,OSR,BT)
%
% PH_G:     This function calculates the frequency and phase functions
%           required for the GMSK modulation. The functions are 
%           generated according to the GSM 05.05 recommendations
%
% SYNTAX:   [g_fun, q_fun] = ph_g(Tb,osr,BT)
%
% INPUT:    Tb      Bit duration (GSM: Tb = 3.692e-6 Sec.)
%           osr     Simulation oversample ratio. osr determines the
%                   number of simulation steps per information bit
%           BT      The bandwidth/bit duration product (GSM: BT = 0.3)
%
% OUTPUT:   g_fun, q_fun   Vectors contaning frequency and phase 
%                          function outputs when evaluated at osr*tb
%
% SUB_FUNC: None
%
% WARNINGS: Modulation length of 3 is assumed !
%
% TEST(S):  Tested through function gsmk_mod.m
%
% AUTHOR:   Jan H. Mikkelsen / Arne Norre Ekstrøm
% EMAIL:    hmi@kom.auc.dk / aneks@kom.auc.dk
%
% $Id: ph_g.m,v 1.6 1998/02/12 10:50:54 aneks Exp $

% SIMULATION SAMPLE FREQUENCY
%
Ts = Tb/OSR;

% PREPARING VECTORS FOR DATA PROCESSING
%
PTV = -2*Tb:Ts:2*Tb;
RTV = -Tb/2:Ts:Tb/2-Ts;

% GENERATE GAUSSIAN SHAPED PULSE
%
sigma = sqrt(log(2))/(2*pi*BT);
gauss = (1/(sqrt(2*pi)*sigma*Tb))*exp(-PTV.^2/(2*sigma^2*Tb^2)); 

% GENERATE RECTANGULAR PULSE
%
rect = 1/(2*Tb)*ones(size(RTV));

% CALCULATE RESULTING FREQUENCY PULSE
%
G_TEMP = conv(gauss,rect);

% TRUNCATING THE FUNCTION TO 3xTb
%
G = G_TEMP(OSR+1:4*OSR); 

% TRUNCATION IMPLIES THAT INTEGRATING THE FREQUENCY PULSE
% FUNCTION WILL NOT EQUAL 0.5, HENCE THE RE-NORMALIZATION
%
G_FUN = (G-G(1))./(2*sum(G-G(1)));

% CALCULATE RESULTING PHASE PULSE
%
Q_FUN = cumsum(G_FUN);