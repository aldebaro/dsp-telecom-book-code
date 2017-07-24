%Step 2b - decode the SCH burst
%Acronyms:
%BCC - Base Station Color Code
%PLM - Public land mobile network
%FN - Frame Number. For each burst the FN is incremented
%by 1 until it reaches 8 * 26 * 51 * 2048 are restarts
%with 1 again. Using FN modulo 51 allows to infer if the
%current burst is at the beginning of a 51-multiframe.

thisBCC=NaN; %initialize
thisPLM=NaN;
for i=1:length(allSCHStarts)
    schStart=allSCHStarts(i);
    [BCC, PLM, FN] = demod_sb(r',schStart); %decode burst
    thisFNmod51=mod(FN,51); %for checking the relative position in multiframe
    if i==1 %first iteration
        %In 51-frames multiframe, following a SB there is BCCH or CCCH
        %The "data" below is a BCCH or CCCH
        first_data_burst_start = schStart + numOfSamplesIn8TimeSlots;
        first_data_burst_frame_number = FN + 1;
        %record BCC and PLM
        thisBCC=BCC;
        thisPLM=PLM;
        disp(['Base Station Color Code, BCC = ' num2str(thisBCC)])
        disp(['Public land mobile net., PLM = ' num2str(thisPLM)])
        disp('SCH frame numbers (FN), which start with FN=0 for the frequency burst:');
    else %check some things that we are assuming
        if thisBCC~=BCC
            warning(['BCC changed to = ' num2str(BCC)])
        end
        if thisPLM~=PLM
            warning(['PLM changed to = ' num2str(PLM)])
        end
        %consider sequence 1,11,21,31,41,1,11...
        if thisFNmod51-previousFNmod51 ~= 10 && thisFNmod51-previousFNmod51 ~= -40
            thisFNmod51
            previousFNmod51
            warning('thisFNmod51-previousFNmod51 ~= 10')
        end
    end
    disp(['FN=' num2str(FN) ', mod(FN,51)=' num2str(thisFNmod51) ...
        ', mod(FN,26)=' num2str(mod(FN,26))])
    previousFNmod51=thisFNmod51; %prepare for next iteration
end


% for i=(fcch_start+5000):50000:length(r)
%     [BCC, PLM, FN] = demod_sb(r',i); %decode burst
%     disp(['Base Station Color Code, BCC = ' num2str(BCC)])
%     disp(['Public land mobile net., PLM = ' num2str(PLM)])
%     disp(['Frame Number, FN = ' num2str(FN)])
%     disp(['FN modulo 51 = ' num2str(mod(FN,51)) ...
%         ' and FN modulo 26 = ' num2str(mod(FN,26))])
%     if first_data_burst_start == 0
%         first_data_burst_start = sync_burst_start + 5000;
%         first_data_burst_frame_number = FN + 1;
%     end
% end
