function [Y, Rhh] = mafi(r,L,T_SEQ,OSR)
%
% MAFI:     This function performes the tasks of channel impulse
%           respons estimation, bit syncronization, matched 
%           filtering and signal sample rate downconversion.
%
% SYNTAX:   [y, Rhh] = mafi(r,Lh,T_SEQ,OSR)
%
% INPUT:    r     Complex baseband representation of the received
%                 GMSK modulated signal
% 	    Lh    The desired length of the matched filter impulse
%                 response measured in bit time durations
% 	    T_SEQ A MSK-modulated representation of the 26 bits long
%                 training sequence used in the transmitted burst, 
%                 i.e. the training sequence used in the generation of r
%           OSR   Oversampling ratio, defined as f_s/r_b.
%
% OUTPUT:   Y     Complex baseband representation of the matched 
%                 filtered and down converted received signal
%
%           Rhh   Autocorrelation of the estimated channel impulse 
%                 response. The format is a Lh+1 unit long column vector 
%                 starting with Rhh[0], and ending with Rhh[Lh]. 
%                 Complex valued.
%
% SUB_FUNC: None
%
% WARNINGS: The channel estimation is based on the 16 most central 
%           bits of the training sequence only
%
% TEST(S):  Tested manually through test script mf_ill.m
%
% AUTOR:    Jan H. Mikkelsen / Arne Norre Ekstrøm
% EMAIL:    hmi@kom.auc.dk / aneks@kom.auc.dk
%
% $Id: mafi.m,v 1.1 1998/10/01 10:20:21 hmi Exp $

DEBUG=0;

% PICK CENTRAL 16 BITS [ B | C | A ] AS COMPROMISE
% AND PERFORM COMPLEX CONJUGATION
%
T16 = conj(T_SEQ(6:21));

% EXTRACT RELEVANT PART OF THE RECEIVED SIGNAL. USING
% GUARD TIMES AS GUIDELINES IMPLIES EXTRACTING THE PART 
% STARTING APPROXIMATELY AT 10 Tb's BEFORE THE 16 MOST 
% CENTRAL TRAINING SEQUENCE BITS AND ENDING APPROXIMATELY
% 10 Tb's AFTER. ASSUME THAT BURSTS TEND TO BE CENTERED IN
% A SAMPLE STREAM.
%
GUARD = 10;
center_r=round(length(r)/2);
start_sub=center_r-(GUARD+8)*OSR;
end_sub=center_r+(GUARD+8)*OSR;
%Aldebaro: Tore increased to:
%start_sub=center_r-(GUARD+27)*OSR;
%end_sub=center_r+(GUARD+27)*OSR;


% YOU MAY WANT TO ENABLE THIS FOR SPECIAL DEBUGGNIG
%
%start_sub=1;
%end_sub=length(r);

r_sub = r(start_sub:end_sub);

if DEBUG,
  % DEBUGGING, VERIFIES THAT WE PICK THE RIGHT PART OUT
  % 
  count=1:length(r);
  figure
  plot(count,real(r));
  plug=start_sub:end_sub;
  hold on;
  plot(plug,real(r_sub),'r')
  hold off;
  title('Real part of r and r_sub (red)');
  %pause;
end

% PREPARE VECTOR FOR DATA PROCESSING
%
chan_est = zeros(1,length(r_sub)-OSR*16);

% ESTIMATE CHANNEL IMPULSE RESPONSE USING ONLY EVERY
% OSR'th SAMPLE IN THE RECEIVED SIGNAL
%
for n = 1:length(chan_est),
  chan_est(n)=r_sub(n:OSR:n+15*OSR)*T16.';
end

if DEBUG,
  % DEBUGGING, PROVIDES A PLOT OF THE ESTIMATED IMPULSE
  % RESPONSE FOR THE USER TO GAZE AT
  figure;
  plot(abs(chan_est));
  title('The absoulte value of the correlation');
  %pause;
end

chan_est = chan_est./16;

% EXTRACTING ESTIMATED IMPULSE RESPONSE BY SEARCHING FOR MAXIMUM
% POWER USING A WINDOW OF LENGTH OSR*(L+1)
%
WL = OSR*(L+1);

search = abs(chan_est).^2;
for n = 1:(length(search)-(WL-1)),
  power_est(n) = sum(search(n:n+WL-1));
end

if DEBUG,
  % DEBUGGING, SHOWS THE POWER ESTIMATE
  figure;
  plot(power_est);
  title('The window powers');
  %pause;
end

% SEARCHING FOR MAXIMUM VALUE POWER WINDOW AND SELECTING THE
% CORRESPONDING ESTIMATED MATCHED FILTER TAP COEFFICIENS. ALSO,
% THE SYNCRONIZATION SAMPLE CORRESPONDING TO THE FIRST SAMPLE
% IN THE T16 TRAINING SEQUENCE IS ESTIMATED
%
[peak, sync_w] = max(power_est);
h_est = chan_est(sync_w:sync_w+WL-1);

[peak, sync_h] = max(abs(h_est));
sync_T16 = sync_w + sync_h - 1;

if DEBUG,
  % DEBUGGING, SHOWS THE POWER ESTIMATE
  figure;
  plot(abs(h_est));
  title('Absolute value of extracted impulse response');
  %pause;
end

% WE WANT TO USE THE FIRST SAMPLE OF THE IMPULSERESPONSE, AND THE
% CORRESPONDING SAMPLES OF THE RECEIVED SIGNAL.
% THE VARIABLE sync_w SHOULD CONTAIN THE BEGINNING OF THE USED PART OF
% TRAINING SEQUENCE, WHICH IS 3+57+1+6=67 BITS INTO THE BURST. THAT IS
% WE HAVE THAT sync_T16 EQUALS FIRST SAMPLE IN BIT NUMBER 67.
%
burst_start = ( start_sub + sync_T16 - 1 ) - ( OSR * 66 + 1 ) + 1;

% COMPENSATING FOR THE 2 Tb DELAY INTRODUCED IN THE GMSK MODULATOR.
% EACH BIT IS STRECHED OVER A PERIOD OF 3 Tb WITH ITS MAXIMUM VALUE
% IN THE LAST BIT PERIOD. HENCE, burst_start IS 2 * OSR MISPLACED. 
%
burst_start = burst_start - 2*OSR + 1;

% CALCULATE AUTOCORRELATION OF CHANNEL IMPULSE
% RESPONS. DOWN CONVERSION IS CARRIED OUT AT THE SAME
% TIME
%
R_temp = xcorr(h_est);

pos = (length(R_temp)+1)/2;

Rhh=R_temp(pos:OSR:pos+L*OSR);

% PERFORM THE ACTUAL MATCHED FILTERING
%

m = length(h_est)-1;

% A SINGLE ZERO IS INSERTED IN FRONT OF r SINCE THERE IS AN EQUAL 
% NUMBER OF SAMPLES IN r_sub WE CANNOT BE TOTALLY CERTAIN WHICH 
% SIDE OF THE MIDDLE THAT IS CHOSEN THUS AN EXTRA SAMPLE IS 
% NEEDED TO AVOID CROSSING ARRAY BOUNDS.
%
GUARDmf = (GUARD+1)*OSR;
r_extended = [ zeros(1,GUARDmf) r zeros(1,m) zeros(1,GUARDmf)];

% RECALL THAT THE ' OPERATOR IN MATLAB DOES CONJUGATION
%

%AK
h_est

for n=1:148,
  aa=GUARDmf+burst_start+(n-1)*OSR;
  bb=GUARDmf+burst_start+(n-1)*OSR+m;
  Y(n) = r_extended(aa:bb)*h_est'; 
end
