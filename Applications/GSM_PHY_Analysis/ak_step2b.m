%Step 2b - decode the burst
%Discard the correction suggested by the cross-correlation
%using the SCH and use the original estimate via FCCH
%The reason is that the correction is of only 2 samples
%and leads to the same results. You can try running:
%fcch_start = fcch_start + 2;

%Acronyms:
%BCC - Base Station Color Code
%PLM - Public land mobile network
%FN - Frame Number. For each burst the FN is incremented 
%by 1 until it reaches 8 * 26 * 51 * 2048 are restarts
%with 1 again. Using FN modulo 51 allows to infer if the
%current burst is at the beginning of a 51-multiframe.

first_data_burst_start = 0;
for n=(fcch_start+5000):50000:length(r)
    [BCC, PLM, FN] = demod_sb(r',n); %decode burst
    disp(['Base Station Color Code, BCC = ' num2str(BCC)])
    disp(['Public land mobile net., PLM = ' num2str(PLM)])
    disp(['Frame Number, FN = ' num2str(FN)])
    if first_data_burst_start == 0
        first_data_burst_start = sync_burst_start + 5000;
        first_data_burst_frame_number = FN + 1;
    end
end
