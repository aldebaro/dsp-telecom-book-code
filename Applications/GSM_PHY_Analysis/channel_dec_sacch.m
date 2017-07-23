function [rx_block,FLAG_SS,PARITY_CHK] = channel_dec_sacch(rx_enc)
%
% channel_dec: 
%
% SYNTAX:     [rx_block, FLAG_SS, PARITY_CHK] = channel_dec(rx_enc)
% 
% INPUT:      rx_enc  A 456 bits long vector contaning the encoded 
%                     data sequence as estimated by the SOVA. The 
%                     format of the sequence must be according to 
%                     the GSM 05.03 encoding scheme
%
% OUTPUT:     rx_block  A 228 bits long vector contaning the final
%                       estimated information data sequence.
%
%             FLAG_SS Indication of correct stop state. Flag is set
%                     to '1' if an error has occured here.
%
%             PARITY_CHK The 3 parity check bit inserted in the 
%                        transmitter.
% 					 
% SUB_FUNC:   None
%
% WARNINGS:   None
%
% TEST(S):    Operation tested in conjunction with the channel_enc.m
%             module. Operation proved to be correct.
%
% AUTHOR:   Jan H. Mikkelsen / Arne Norre Ekstrøm
% EMAIL:    hmi@kom.auc.dk / aneks@kom.auc.dk
%
% $Id: channel_dec.m,v 1.8 1998/02/12 10:53:13 aneks Exp $

L = length(rx_enc);

% TEST INPUT DATA
%
if L ~= 456
  disp(' ')
  disp('Input data sequence size violation. Program terminated.')
  disp(' ') 
%  break;
end

c1 = rx_enc(1:L);

% INITIALIZE VARIOUS MATRIXES
%
% REMEMBER THE VA DECODER OPERATES ON DI-BITS
% HENCE ONLY 456/2 = 228 STATE TRANSITIONS OCCURE
%

START_STATE = 1;
END_STATE = 1;

STATE = zeros(16,228);
METRIC = zeros(16,2);

NEXT = zeros(16,2);
zeroin = 1;
onein = 9;
for n = 1:2:15,
  NEXT(n,:) = [zeroin onein];
  NEXT(n+1,:) = NEXT(n,:);
  zeroin = zeroin + 1;
  onein = onein + 1; 
end

PREVIOUS = zeros(16,2);
offset = 0;
for n = 1:8,
  PREVIOUS(n,:) = [n+offset n+offset+1];
  offset = offset + 1;
end
PREVIOUS = [ PREVIOUS(1:8,:) ; PREVIOUS(1:8,:)];

% SETUP OF DIBIT DECODER TABLE. THE BINARY DIBITS ARE
% HERE REPRESENTED USING DECIMAL NUMBER, I.E. THE DIBIT
% 00 IS REPRESENTED AS 0 AND THE DIBIT 11 AS 3
%
% THE TABEL IS SETUP SO THAT THE CALL DIBIT(X,Y) RETURNS
% THE DIBIT SYMBOL RESULTING FROM A STATE TRANSITION FROM
% STATE X TO STATE Y
% 

DIBIT = [  0 NaN NaN NaN NaN NaN NaN NaN   3 NaN NaN NaN NaN NaN NaN NaN;
	   3 NaN NaN NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN;
	 NaN   3 NaN NaN NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN;
	 NaN   0 NaN NaN NaN NaN NaN NaN NaN   3 NaN NaN NaN NaN NaN NaN;
	 NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   3 NaN NaN NaN NaN NaN;
	 NaN NaN   3 NaN NaN NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN;
	 NaN NaN NaN   3 NaN NaN NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN;
	 NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   3 NaN NaN NaN NaN;
	 NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN NaN NaN   2 NaN NaN NaN;
	 NaN NaN NaN NaN   2 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN;
	 NaN NaN NaN NaN NaN   2 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN;
	 NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN NaN NaN   2 NaN NaN;
	 NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN NaN NaN   2 NaN;
	 NaN NaN NaN NaN NaN NaN   2 NaN NaN NaN NaN NaN NaN NaN   1 NaN;
	 NaN NaN NaN NaN NaN NaN NaN   2 NaN NaN NaN NaN NaN NaN NaN   1;
	 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN NaN NaN   2];

% SETUP OF BIT DECODER TABLE. 
% THE TABEL IS SETUP SO THAT THE CALL BIT(X,Y) RETURNS
% THE DECODED BIT RESULTING FROM A STATE TRANSITION FROM
% STATE X TO STATE Y
% 					
       
BIT = [  0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN NaN NaN;
	 0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN NaN NaN;
       NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN NaN;
       NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN NaN;
       NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN;
       NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN NaN;
       NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN;
       NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN NaN;
       NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN;
       NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN NaN;
       NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN;
       NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN NaN;
       NaN NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN;
       NaN NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1 NaN;
       NaN NaN NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1;
       NaN NaN NaN NaN NaN NaN NaN   0 NaN NaN NaN NaN NaN NaN NaN   1];
       
% STARTUP METRIK CALCULATIONS.
%
% THIS IS TO REDUCE THE NUMBER OF CALCULATIONS REQUIRED
% AND IT IT RUN ONLY FOR THE FIRST 4 DIBIT PAIRS
%
	   
VISITED_STATES = START_STATE;
for n = 0:3,

  rx_DIBITXy = c1(2*n + 1); 
  rx_DIBITxY = c1(2*n + 1 + 1);

  for k = 1:length(VISITED_STATES),

    PRESENT_STATE = VISITED_STATES(k);
    
    next_state_0 = NEXT(PRESENT_STATE,1);  
    next_state_1 = NEXT(PRESENT_STATE,2);
    
    symbol_0 = DIBIT(PRESENT_STATE,next_state_0);
    symbol_1 = DIBIT(PRESENT_STATE,next_state_1);
        
    if symbol_0 == 0
      LAMBDA = xor(rx_DIBITXy,0) + xor(rx_DIBITxY,0);
    end
    if symbol_0 == 1
      LAMBDA = xor(rx_DIBITXy,0) + xor(rx_DIBITxY,1);
    end
    if symbol_0 == 2
      LAMBDA = xor(rx_DIBITXy,1) + xor(rx_DIBITxY,0);
    end
    if symbol_0 == 3
      LAMBDA = xor(rx_DIBITXy,1) + xor(rx_DIBITxY,1);
    end
    
    METRIC(next_state_0,2) = METRIC(PRESENT_STATE,1) + LAMBDA;

    if symbol_1 == 0
      LAMBDA = xor(rx_DIBITXy,0) + xor(rx_DIBITxY,0);
    end
    if symbol_1 == 1
      LAMBDA = xor(rx_DIBITXy,0) + xor(rx_DIBITxY,1);
    end
    if symbol_1 == 2
      LAMBDA = xor(rx_DIBITXy,1) + xor(rx_DIBITxY,0);
    end
    if symbol_1 == 3
      LAMBDA = xor(rx_DIBITXy,1) + xor(rx_DIBITxY,1);
    end
    
    METRIC(next_state_1,2) = METRIC(PRESENT_STATE,1) + LAMBDA;
    STATE([next_state_0, next_state_1],n + 1) = PRESENT_STATE; 

    if k == 1
      PROCESSED = [next_state_0 next_state_1]; 
    else
      PROCESSED = [PROCESSED next_state_0 next_state_1];  
    end
  end	   

  VISITED_STATES = PROCESSED;
  METRIC(:,1) = METRIC(:,2);
  METRIC(:,2) = 0; 
end


% STARTING THE SECTION WHERE ALL STATES ARE RUN THROUGH
% IN THE METRIC CALCULATIONS. THIS GOES ON FOR THE
% REMAINING DIBITS RECEIVED
%

for n = 4:227,
  
  rx_DIBITXy = c1(2*n + 1); 
  rx_DIBITxY = c1(2*n + 1 + 1);

  for k = 1:16,
    
    prev_state_1 = PREVIOUS(k,1);
    prev_state_2 = PREVIOUS(k,2);
	   
    symbol_1 = DIBIT(prev_state_1,k);
    symbol_2 = DIBIT(prev_state_2,k);
        
    if symbol_1 == 0
      LAMBDA_1 = xor(rx_DIBITXy,0) + xor(rx_DIBITxY,0);
    end
    if symbol_1 == 1
      LAMBDA_1 = xor(rx_DIBITXy,0) + xor(rx_DIBITxY,1);
    end
    if symbol_1 == 2
      LAMBDA_1 = xor(rx_DIBITXy,1) + xor(rx_DIBITxY,0);
    end
    if symbol_1 == 3
      LAMBDA_1 = xor(rx_DIBITXy,1) + xor(rx_DIBITxY,1);
    end   
	   
    if symbol_2 == 0
      LAMBDA_2 = xor(rx_DIBITXy,0) + xor(rx_DIBITxY,0);
    end
    if symbol_2 == 1
      LAMBDA_2 = xor(rx_DIBITXy,0) + xor(rx_DIBITxY,1);
    end
    if symbol_2 == 2
      LAMBDA_2 = xor(rx_DIBITXy,1) + xor(rx_DIBITxY,0);
    end
    if symbol_2 == 3
      LAMBDA_2 = xor(rx_DIBITXy,1) + xor(rx_DIBITxY,1);
    end     
	   
    METRIC_1 = METRIC(prev_state_1,1) + LAMBDA_1;
    METRIC_2 = METRIC(prev_state_2,1) + LAMBDA_2;
    
    if METRIC_1 < METRIC_2
      METRIC(k,2) = METRIC_1;
      STATE(k,n+1) = prev_state_1;
    else
      METRIC(k,2) = METRIC_2;
      STATE(k,n+1) = prev_state_2;
    end
  end

  METRIC(:,1) = METRIC(:,2);
  METRIC(:,2) = 0;

end

% STARTING BACKTRACKING TO DETERMINE THE MOST
% PROBABLE STATE TRANSITION SEQUENCE
%

STATE_SEQ = zeros(1,228);

[STOP_METRIC, STOP_STATE] = min(METRIC(:,1));

if STOP_STATE == END_STATE
  FLAG_SS = 0;
else
  FLAG_SS = 1;
end

STATE_SEQ(228) = STOP_STATE;

for n = 227:-1:1,
  STATE_SEQ(n) = STATE(STATE_SEQ(n+1), n+1);
end

STATE_SEQ = [START_STATE STATE_SEQ];

% RESOLVING THE CORRESPONDING BIT SEQUENCS
%

for n = 1:length(STATE_SEQ)-1,
  DECONV_DATA(n) =  BIT(STATE_SEQ(n), STATE_SEQ(n+1));
end

% SEPARATING THE DATA ACCORDING TO THE ENCODING 
% RESULTING FROM THE TRANSMITTER.
%

DATA_I = DECONV_DATA(1:184);
PARITY_CHK = DECONV_DATA(185:224);
TAIL_BITS = DECONV_DATA(225:228);

rx_block = [DATA_I];
