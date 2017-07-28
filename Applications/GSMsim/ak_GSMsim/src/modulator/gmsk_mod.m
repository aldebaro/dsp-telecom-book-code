function [I,Q] = gmsk_mod(BURST,Tb,OSR,BT)
%
% gmsk_mod:   This function accepts a GSM burst bit sequence and
%             performs a GMSK modulation of the sequence. The
%             modulation is according to the GSM 05.05 recommendations
%
% SYNTAX:     [i,q] = gmsk_mod(burst,Tb,osr,BT)
%
% INPUT:      burst   A differential encoded bit sequence (-1,+1)
%             Tb      Bit duration (GSM: Tb = 3.692e-6 Sec.)
%             osr     Simulation oversample ratio. osr determines the
%                     number of simulation steps per information bit
%             BT      The bandwidth/bit duration product (GSM: BT = 0.3)
%
% OUTPUT:     i,q     In-phase (i) and quadrature-phase (q) baseband
%                     representation of the GMSK modulated input burst
%                     sequence
%
% SUB_FUNC:   ph_g.m  This sub-function is required in generating the
%                     frequency and phase pulse functions.
%
% WARNINGS:   Sub-function ph_g.m assumes a 3xTb frequency pulse
%             truncation time
%
% TEST(S):    Function tested using the following relations
%
%             i)
%
%             I^2 + Q^2 = Cos(a)^2 + Sin(a)^2 = 1
%
%             ii)
%
%             When the input consists of all 1's the resulting baseband
% 	      outputs the function should return a sinusoidal signal of
%             frequency rb/4, i.e. a signal having a time period of
%             approximately 4*Tb = 4*3.692e-6 s = 1.48e-5 s for GSM
%
% AUTHOR:   Jan H. Mikkelsen / Arne Norre Ekstrøm
% EMAIL:    hmi@kom.auc.dk / aneks@kom.auc.dk
%
% $Id: gmsk_mod.m,v 1.5 1998/02/12 10:50:10 aneks Exp $

%TO-DO:
%AK: When oversampling is 4, this function returns I and Q with
%600 samples, which corresponds to 150 bits, not 148 bits for the
%burst. I think it deserves correction.

% ACCUIRE GMSK FREQUENCY PULSE AND PHASE FUNCTION
%
[g,q] = ph_g(Tb,OSR,BT);

% PREPARE VECTOR FOR DATA PROCESSING
%
bits = length(BURST);
f_res = zeros(1,(bits+2)*OSR);

% GENERATE RESULTING FREQUENCY PULSE SEQUENCE
if 1
    %the duration of g is 12 samples and OSR=4, so g spans 3 symbols
    %the cummulative sum below is equivalent to a convolution
    for n = 1:bits,
        f_res((n-1)*OSR+1:(n+2)*OSR) = f_res((n-1)*OSR+1:(n+2)*OSR) + BURST(n).*g;
    end
else
    %use convolution
    f_res(1:OSR:length(BURST)*OSR)=BURST; %oversampled signal
    f_res=conv(g,f_res); %convolve
    f_res=f_res(1:end-(length(g)-1)); %take out the convolution tail 
end

% CALCULATE RESULTING PHASE FUNCTION
%
theta = pi*cumsum(f_res);  %AK: why not pi/2  ?? Does g incorporates /2 ?

% PREPARE DATA FOR OUTPUT
%
I = cos(theta);
Q = sin(theta);