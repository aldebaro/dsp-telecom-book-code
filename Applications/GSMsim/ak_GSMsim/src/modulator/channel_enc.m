function [tx_enc] = chan_enc(tx_block)
%
% chan_enc:   This function accepts a 260 bits long vector contaning the 
%             data sequence intended for transmission. The length of 
%             the vector is expanded by channel encoding to form a data
%             block with a length of 456 bits as required in a normal 
%             GSM burst. 
%
%             [ Class I | Class II ]
%             [   182   |    78    ]
%             
%             [ Class Ia | Class Ib | Class II ]
%             [    50    |    132   |    78    ]
%   
%             The Class Ia bits are separatly parity encoded whereby 3 error
%             control bits are added. Subsequently, the Class Ia bits are
%             combined with the Class Ib bits for convolutional encoding
%             according to GSM 05.05. The Class II bits are left unprotected
%
% SYNTAX:     [tx_enc] = channel_enc(tx_block)
% 
% INPUT:      tx_block   A 260 bits long vector contaning the data sequence 
%                        intended for transmission.
%
% OUTPUT:     tx_enc   A 456 bits long vector contaning the encoded data 
%                      sequence
%
% SUB_FUNC:   None
%
% WARNINGS:   None
%
% TEST(S):    Parity encoding - tested to operate correctly.
%             Convolution encoding - tested to operate correctly. 
%
% AUTHOR:   Jan H. Mikkelsen / Arne Norre Ekstrøm
% EMAIL:    hmi@kom.auc.dk / aneks@kom.auc.dk
%
% $Id: channel_enc.m,v 1.9 1998/02/12 10:48:31 aneks Exp $

L = length(tx_block);

% INPUT CHECK
%
if L ~= 260
  disp(' ')
  disp('Input data sequence size violation. Program terminated.')
  disp(' ') 
  return;   %Aldebaro: I changed from break;
end

% SEPARATE INPUT IN RESPECTIVE CLASSES
%
c1a = tx_block(1:50); 
c1b = tx_block(51:182);
c2 = tx_block(183:260);
 
% PARITY ENCODING. THREE CHECK BITS ARE ADDED
%
g = [1 0 1 1];
d = [c1a 0 0 0];
[q,r] = deconv(d,g);

% ADJUST RESULT TO BINARY REPRESENTATION
%
L = length(r);
out = abs(r(L-2:L));
for n = 1:length(out),
  if ceil(out(n)/2) ~= floor(out(n)/2)
    out(n) = 1;
  else
    out(n) = 0;
  end
end

c1a = [c1a out];

% CLASS I BITS ARE COMBINED AND 4 TAIL BITS, {0000}, ARE ADDED AS 
% PRESCRIBED IN THE GSM RECOMMENDATION 05.03
%
c1 = [c1a c1b 0 0 0 0];

% CONVOLUTIONAL ENCODING OF THE RANDOM DATA BITS. THE ENCODING IS
% ACCORDING TO GSM 05.05
%
register = zeros(1,4);
data_seq = [register c1];
enc_a = zeros(1,189);
enc_b = zeros(1,189);
encoded = zeros(1,378);

for n=1:189,  
  enc_a(n) = xor( xor( data_seq(n+4),data_seq(n+1) ), data_seq(n) );
  enc_temp = xor( data_seq(n+4),data_seq(n+3) );
  enc_b(n) = xor ( xor( enc_temp, data_seq(n+1) ), data_seq(n));  
  encoded(2*n-1) = enc_a(n);
  encoded(2*n) = enc_b(n);
  clear enc_temp
end

% PREPARE DATA FOR OUTPUT
%
tx_enc = [encoded c2];

