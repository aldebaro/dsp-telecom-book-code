function encoded = ak_encodeSB(data)
%AK: TO-DO, READ pag. 23 from GSM Reference: TS/SMG-020503QR1
%ICS: 33.060.50 about the block code

% PARITY ENCODING. THREE CHECK BITS ARE ADDED
% GSM uses a cyclic block code
if 0
    g = [1 0 1 1]; %generator polynomial (AK: is it the same??)
    d = [sb_data zeros(1,10)]; %add extra bits ???
    [q,r] = deconv(d,g); %make the polynomial division
    blockCodedData=mod(r,2);
else
    %not doing coding, just adding zeros as parity bits
    blockCodedData=[data zeros(1,10)];
end

%From:
%http://www.rfwireless-world.com/Articles/gsm-control-channel-processing-through-physical-layer.html
%Convolutional encoder to give out 78 bits same as processed for TCH/FS.
% CONVOLUTIONAL ENCODING OF THE RANDOM DATA BITS. THE ENCODING IS
% ACCORDING TO GSM 05.05
if 0 %using Mathworks' functions
    %10011 - octal: 23
    %11011 - octal: 33
    trellis = poly2trellis(5,[23 33]);
    blockCodedData=blockCodedData(:); %make it a column vector
    % Create a ConvolutionalEncoder System object
    hConvEnc = comm.ConvolutionalEncoder(trellis);
    encoded = step(hConvEnc,blockCodedData); % Encode the data.
    encoded = transpose(encoded);
else
    
    %Will use the same as GSMsim:
    register = zeros(1,4);
    data_seq = [register blockCodedData zeros(1,4)];
    enc_a = zeros(1,35);
    enc_b = zeros(1,35);
    encoded = zeros(1,78);
    
    for n=1:35,
        enc_a(n) = xor( xor( data_seq(n+4),data_seq(n+1) ), data_seq(n) );
        enc_temp = xor( data_seq(n+4),data_seq(n+3) );
        enc_b(n) = xor ( xor( enc_temp, data_seq(n+1) ), data_seq(n));
        encoded(2*n-1) = enc_a(n);
        encoded(2*n) = enc_b(n);
        clear enc_temp
    end
end