%ak_step3_v2 - Channel decoding for normal bursts (BCCH and CCCH)
%In 51-frames multiframe, following a SB there is BCCH or CCCH
%The "data" below is a BCCH or CCCH.

verbosity = 0;
L = length(r); %total number of samples
%AK: not using below, but do not know what subtract 10 samples!
%offset = first_data_burst_start - 10;

N=floor(L/numOfSamplesIn8TimeSlots);
disp(['There are ' num2str(N) ' frames in this signal'])

rx_data_matrix1=zeros(4,114); %space for data (114 bits) of 4 bursts
for i=1:length(allSCHStarts)
    schStart=allSCHStarts(i);
    [BCC, PLM, FN] = demod_sb(r',schStart); %decode burst
    thisSCHFNmod51=mod(FN,51); %for checking the relative position in multiframe
    %each SB is followed by BBBBCCCC (first SB in multiframe) or CCCCCCCC
    for blockNumber=1:2 
        blockStart=schStart+numOfSamplesIn8TimeSlots+...
            (blockNumber-1)*4*numOfSamplesIn8TimeSlots;
        for n=1:4 %a block (BCCH or CCCH) has 4 bursts
            % Calculate start and end of the next burst
            burst_start = blockStart + (n-1) * numOfSamplesIn8TimeSlots;
            burst_end   = burst_start + 599;
            % Quit if its not in the file
            if burst_end > L
                break
            end
            if verbosity > 1
                % Plot the burst
                plotframe2((r(burst_start:burst_end)))
            end
            %Demodulate    
            frame_number = FN+4*(blockNumber-1)+n;
            %frame_number = (first_data_burst_frame_number + (n-1) + 4 * (m-1) + 10 * (k-1));
            rx_burst = demod_nb(r',burst_start); %demodulate a normal burst
            
            %Must store data from 4 bursts before we have a complete message
            %rx_burst has 148 bits and DeMUX returns 114 data bits
            %(including the stealing bits)
            rx_data_matrix1(n,:)=DeMUX(rx_burst);
            %pause
        end
        
        % Avoid error messages if we broke out of the for loop
        if burst_end < L
            rx_enc=deinterleave( [ rx_data_matrix1 ; rx_data_matrix1 ] );
            [rx_block1,FLAG_SS,PARITY_CHK]=channel_dec_sacch(rx_enc);
            check_parity_sacch(rx_block1, PARITY_CHK);
            frame_number_mod_51 = mod(frame_number, 51);
            %frame number (FN) starts from 0, which is the FB, then SB is
            %1 and the end of the BCCH if FN=5
            if frame_number_mod_51 == 5
                if thisSCHFNmod51 ~= 1
                    error('Error in logic: thisSCHFNmod51 ~= 1')
                end
                disp(['FN=' num2str(frame_number) ' is BCCH'])
            else
                disp(['FN=' num2str(frame_number) ' is CCCH'])
            end
            if verbosity > 1
                message=view_oct(rx_block1) %display decoded bits
            end
            %pause
        end
    end
end
