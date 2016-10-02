function T_SEQ = T_SEQ_gen(TRAINING)
%
% T_SEQ_GEN:
%           This function generates the MSK-mapped version of the 
%           training sequence used in the GSMsim package.
%
% SYNTAX:   T_SEQ = T_SEQ_gen(TRAINING)
%
% INPUT:    TRAINING: The training sequence represented as bits. (0's and 1's)
%
% OUTPUT:     T_SEQ: A MSK-mapped representation of the 26 bits long
%                    training sequence.
%
% SUB_FUNC: None
%
% WARNINGS: First MSK symbol is set to 1. This may be a problem!!!
%
% TEST(S):  Result is verified against those reported by 95gr870T
%
% AUTOR:    Arne Norre Ekstrøm / Jan H. Mikkelsen
% EMAIL:    aneks@kom.auc.dk / hmi@kom.auc.dk
%
% $Id: T_SEQ_gen.m,v 1.5 1998/02/12 10:59:07 aneks Exp $

% TEST TO SEE WETHER THE LENGTH OF Ic IS CORRECT.
% IF NOT, THEN ABORT...
%
if length(TRAINING) ~= 26 
  error('TRAINING is not of length 26, terminating.');
end

% MAKE A POLAR VERSION OF TRAINING
TRAININGPol=(2.*TRAINING)-1;

% DO DIFFERENTIAL ENCODING OF THE BITS
%
for n=2:length(TRAININGPol)
  a(n)=TRAININGPol(n)*TRAININGPol(n-1);
end

% DO GMSK MAPPING OF POLAR a(n)
%
% THIS IS A CHOICE, AND IT MAY BE WRONG!!!!!!
T_SEQ(1)=1;
for n=2:length(TRAININGPol)
  T_SEQ(n)=j*a(n)*T_SEQ(n-1);
end