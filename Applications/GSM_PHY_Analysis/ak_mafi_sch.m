function [Y, Rhh] = ak_mafi_sch(r,L,T_SEQ,OSR)
%
% AK_MAFI_SCH: Estimates the channel impulse, performs bit
% syncronization, matched filtering and downconversion
% to the baud rate. Assumes the burst is a synchronization
% burst (not a normal burst).
%
% SYNTAX:   [y, Rhh] = ak_mafi_sch(r,Lh,T_SEQ,OSR)
%
% INPUTS:r Complex baseband representation of the received
%          GMSK modulated signal
% 	    Lh The estimated length of the matched filter
%          impulse response measured in symbols durations.
%          It cannot be larger than 4 because of the
%          properties of the autocorrelation of the GSM
%          training sequence.
% 	    T_SEQ A MSK-modulated representation of the 26
%          bits long training sequence used in the
%          normal burst, i.e. the training sequence used
%          in the generation of r
%       OSR Oversampling ratio, defined as F_s/Rsym.
%
% OUTPUTS:
%       Y  Complex baseband representation of the
%          matched filtered and down converted received
%          signal
%
%       Rhh  Autocorrelation of the estimated channel
%            impulse response. The format is a Lh+1 unit
%            long column vector starting with Rhh[0],
%            and ending with Rhh[Lh]. Complex valued.
%
% WARNINGS: The channel estimation is based on the 16 most
%           central bits of the training sequence only
%
% AUTOR:    Jan H. Mikkelsen / Arne Norre Ekstrøm
% EMAIL:    hmi@kom.auc.dk / aneks@kom.auc.dk
% Modified by Aldebaro, Nov. 2010.

DEBUG=0;

% PICK CENTRAL 16 BITS [ B | C | A ] AS COMPROMISE
% AND PERFORM COMPLEX CONJUGATION
%
%T16 = conj(T_SEQ(6:59)); %from 21 to 59

% EXTRACT RELEVANT PART OF THE RECEIVED SIGNAL. USING
% GUARD TIMES AS GUIDELINES IMPLIES EXTRACTING THE PART
% STARTING APPROXIMATELY AT 10 Tb's BEFORE THE 16 MOST
% CENTRAL TRAINING SEQUENCE BITS AND ENDING APPROXIMATELY
% 10 Tb's AFTER. ASSUME THAT BURSTS TEND TO BE CENTERED IN
% A SAMPLE STREAM.
% There are other training sequences, but this code
% assumes the one with 26 bits. Larger values of GUARD
% can be used for SCH longer training sequences.
GUARD = 10;
if 0
    %do not use the whole burst:
    center_r=round(length(r)/2);
    start_sub=center_r-(GUARD+27)*OSR; %8 to 27
    end_sub=center_r+(GUARD+27)*OSR; %8 to 27
else
    % YOU MAY WANT TO ENABLE THIS FOR SPECIAL DEBUGGNIG
    %Use the whole burst, and override previous values
    start_sub=1;
    end_sub=length(r);
end
r_sub = r(start_sub:end_sub); 

if DEBUG,
    % DEBUGGING, VERIFIES THAT WE PICK THE RIGHT PART OUT
    count=1:length(r);
    plot(count,real(r));
    plug=start_sub:end_sub;
    hold on;
    plot(plug,real(r_sub),'r')
    hold off;
    title('Real part of r and r_sub (red)');
    pause;
end

%assume the training sequence for SCH bursts:
SYNCBITS = [1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 1];
syncseq = T_SEQ_gen(SYNCBITS);
T16 = conj(syncseq(6:59)); %called T16, but now longer

%Estimate the cross correlation between r_sub and T16.
%Note that r_sub is at oversampled by OSR while T16 is
%at the symbol rate. So, use only every OSR'th sample of
%the received burst
%Pre-allocate space:
crossCorrelation = zeros(1,length(r_sub)-OSR*length(T16));
for n = 1:length(crossCorrelation),
    %crossCorrelation(n)=r_sub(n:OSR:n+15*OSR)*T16.';
    %chan_est(n)=T16 * conj(r_sub(n:OSR:n+(length(T16)-1)*OSR));
    crossCorrelation(n)=r_sub(n:OSR:n+(length(T16)-1)*OSR)*T16.';    
end

if DEBUG,
    plot(abs(crossCorrelation));
    title('The absoulte value of the correlation');
    pause;
end

%Normalize by 16, which is the peak of the autocorrelation
%function for T16. The array chan_est contains the 
%estimated channel, but it is necessay to find its start
%and end
chan_est = crossCorrelation./54; %16 to 54

%Use a sliding window to calculate the power and locate
%the channel transfer function. Search for maximum energy.
WL = OSR*(L+1); % window of length OSR*(L+1)
instantaneousPower = abs(chan_est).^2;
windowEnergy = zeros(1,length(instantaneousPower)-(WL-1));
for n = 1:(length(instantaneousPower)-(WL-1)),
    windowEnergy(n) = sum(instantaneousPower(n:n+WL-1));
end

if DEBUG,    
    plot(windowEnergy); %SHOWS THE energy ESTIMATE
    title('The energy per window');
    pause;
end

%The window with maximum energy is assumed to have the
%peak of the autocorrelation function. Also, the procedure
%allows to perform synchronization via the peak of h_est
[peak, sync_w] = max(windowEnergy);
h_est = chan_est(sync_w:sync_w+WL-1);
[peak, sync_h] = max(abs(h_est));
sync_T16 = sync_w + sync_h - 1;

if DEBUG,
    plot(abs(h_est));
    title('Absolute value of extracted impulse response');
    pause;
end

%For a normal burst (see ak_mafi.m), one would have 
% a TRAINING SEQUENCE, WHICH IS 3+57+1+6=67 BITS INTO THE
% BURST. THAT IS WE would HAVE THAT sync_T16 EQUALS FIRST 
% SAMPLE IN BIT NUMBER 67. Now, for the sync burst:
% WE WANT TO USE THE FIRST SAMPLE OF THE IMPULSE RESPONSE,
% AND THE CORRESPONDING SAMPLES OF THE RECEIVED SIGNAL.
% THE VARIABLE sync_w SHOULD CONTAIN THE BEGINNING OF THE
% USED PART OF TRAINING SEQUENCE, WHICH IS 3+39+6=48
% BITS INTO THE BURST. THAT IS WE HAVE THAT sync_T16
% EQUALS FIRST SAMPLE IN BIT NUMBER 47.
% Note it is 48, while ak_mafi used 66 (67-1)
burst_start = (start_sub + sync_T16-1)-(OSR * 48 + 1) + 1;

% COMPENSATING FOR THE 2 Tb DELAY INTRODUCED IN THE GMSK
% MODULATOR. EACH BIT IS STRECHED OVER A PERIOD OF 3 Tb
% WITH ITS MAXIMUM VALUE IN THE LAST BIT PERIOD. HENCE, 
% burst_start IS 2 * OSR MISPLACED.
burst_start = burst_start - 2*OSR + 1;

% CALCULATE AUTOCORRELATION OF CHANNEL IMPULSE
% RESPONSE. DOWN CONVERSION IS CARRIED OUT later
R_temp = xcorr(h_est);
pos = (length(R_temp)+1)/2;
Rhh=R_temp(pos:OSR:pos+L*OSR);

% PERFORM THE ACTUAL MATCHED FILTERING:

% A SINGLE ZERO IS INSERTED IN FRONT OF r SINCE THERE IS
% AN EQUAL NUMBER OF SAMPLES IN r_sub WE CANNOT BE TOTALLY 
% CERTAIN WHICH SIDE OF THE MIDDLE THAT IS CHOSEN THUS AN
% EXTRA SAMPLE IS NEEDED TO AVOID CROSSING ARRAY BOUNDS.
m = length(h_est)-1; %number of extra zero samples
GUARDmf = (GUARD+1)*OSR;
r_extended=[zeros(1,GUARDmf) r zeros(1,m) ...
    zeros(1,GUARDmf)];

% RECALL THAT THE ' OPERATOR IN MATLAB DOES CONJUGATION
Y = zeros(1,148); %pre-allocate space
for n=1:148,
    aa=GUARDmf+burst_start+(n-1)*OSR; %start sample
    bb=GUARDmf+burst_start+(n-1)*OSR+m; %end sample
    Y(n) = r_extended(aa:bb)*h_est'; %matched filtering
end
