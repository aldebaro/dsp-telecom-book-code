function DIFF_ENC_DATA = diff_enc(BURST)
%
% diff_enc:   This function accepts a GSM burst bit sequence and
%             performs a differential encoding of the sequence. The
%             encoding is according to the GSM 05.05 recommendations
%
%             Input: D(i)
%             Output: A(i)
%
%             D'(I) = D(i) (+) D(i-1)  ; (+) = XOR
%                D(i), D'(i) = {0,1}
%             A(i) = 1 - 2*D'(i)
%                A(i) = {-1,1}
%
% SYNTAX:     [diff_enc_data] = diff_enc(burst)
%
% INPUT:      burst   A binary, (0,1), bit sequence
%
% OUTPUT:     diff_enc_data   A differential encoded, (+1,-1), version 
% 			      of the input burst sequence
% 					
% SUB_FUNC:   None
%
% WARNINGS:   None
%
% TEST(S):    Function tested  
%
% AUTHOR:   Jan H. Mikkelsen / Arne Norre Ekstrøm
% EMAIL:    hmi@kom.auc.dk / aneks@kom.auc.dk
%
% $Id: diff_enc.m,v 1.5 1998/02/12 10:49:36 aneks Exp $

L = length(BURST);
 
% INTERMEDIATE VECTORS FOR DATA PROCESSING
%
d_hat = zeros(1,L);
alpha = zeros(1,L);

% DIFFERENTIAL ENCODING ACCORDING TO GSM 05.05
% AN INFINITE SEQUENCE OF 1'ENS ARE ASSUMED TO
% PRECEED THE ACTUAL BURST
%
data = [1 BURST];
for n = 1+1:(L+1),
  d_hat(n-1) = xor( data(n),data(n-1) );
end
alpha = 1 - 2.*d_hat;

% PREPARING DATA FOR OUTPUT
%
DIFF_ENC_DATA = alpha;