function [tx_enc] = channel_enc(tx_block)
%
% Obs, from http://www.edaboard.com/thread97140.html
% GSM divides output of the RPE-LTP speech coder into 3 categories:
% 1-50 bits called "Very Important bits"
% 2-132 bits called "Important bits"
% 3-78 bits called " Not so Important bits"
%
% the 50 bits are very important for having intelligible speech,
% so they're applied to both block coder and 1/2 rate convolutional
% encoder .The 132 bits are important but not as important as the 50
% bits so they're applied only to the convolutional encoder. Speech
% can be understood even if an error occured at the last 78 bits so
% no channel coding is applied to them .Afterwards, interleaving is
% apllied to mitigate burst errors .
%%
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
% GSM uses a cyclic block code
g = [1 0 1 1]; %generator polynomial
d = [c1a 0 0 0]; %message to be encoded
[q,r] = deconv(d,g); %last bits of remainder r are the parity bits

if 0  %original (slow) code:
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
else
    %faster code:
    out = mod(r(end-2:end),2); %extract three last bits and convert to binary
end

c1a = [c1a out];

% CLASS I BITS ARE COMBINED AND 4 TAIL BITS, {0000}, ARE ADDED AS
% PRESCRIBED IN THE GSM RECOMMENDATION 05.03
%
c1 = [c1a c1b 0 0 0 0];

% CONVOLUTIONAL ENCODING OF THE RANDOM DATA BITS. THE ENCODING IS
% ACCORDING TO GSM 05.05
if 0 %using Mathworks' functions
    %10011 - octal: 23
    %11011 - octal: 33
    trellis = poly2trellis(5,[23 33]);
    % Create a ConvolutionalEncoder System object
    hConvEnc = comm.ConvolutionalEncoder(trellis);
    c1=c1(:); %make it a column vector
    encoded = step(hConvEnc,c1); % Encode the data.
    encoded = transpose(encoded);
else
    %original (slow) implementation
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
end
% PREPARE DATA FOR OUTPUT
%
tx_enc = [encoded c2];

