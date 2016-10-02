numOfBurts =10; %number of bursts
Lh=2; %channel dispersion: length of the channel impulse
%response minus one.
showPlots=1;
shouldAddNoise = 1; %add AWGN noise if 1
gsm_set; %set some variables
%pre-compute tables used by Viterbi:
[SYMBOLS,PREVIOUS,NEXT,START,STOPS] = viterbi_init(Lh);
B_ERRS=0; %reset counter for number of bit errors
for n=1:numOfBurts;
    tx_data = data_gen(INIT_L); %randomly generate a burst
    %modulate a burst
    [burst, I, Q] = gsm_mod(Tb,OSR,BT,tx_data,TRAINING);
    %pass signal over the channel
    if shouldAddNoise == 1
        [r,snrdB]=channel_simulator(I,Q,OSR);
        if n==1 %show SNR only for the first burst
            disp(['SNR = ' num2str(snrdB) ' dB']);
        end
    else
        r = I + j*Q; %no channel: noise and ISI free
    end
    %matched filtering:
    [Y, Rhh] = ak_mafi(r,Lh,T_SEQ,OSR);
    %decoding using Viterbi:
    rx_burst = viterbi_detector(SYMBOLS,NEXT,PREVIOUS,...
        START,STOPS,Y,Rhh);
    rx_data=DeMUX(rx_burst); %demultiplexing
    B_ERRS=B_ERRS+sum(xor(tx_data,rx_data)); %count errors
end
BER=(B_ERRS*100)/(numOfBurts*148); %calculate BER
fprintf(1,'There were %d Bit-Errors\n',B_ERRS);
fprintf(1,['This equals %2.1f Percent of the checked ' ...
    'bits.\n'],BER);