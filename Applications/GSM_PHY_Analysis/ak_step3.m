% Channel decoding

L = length(r);
offset = first_data_burst_start - 10;

for k=1:3
  for m=1:2
    block_start = offset + (m-1) * 20000 + (k-1) * 50000;
    for n=1:4
        
      % Calculate start and end of the next burst
      burst_start = block_start + (n-1) * 5000;
      burst_end   = burst_start + 599;
      % Quit if its not in the file
      if burst_end > L
          break;
      end;
      
      % Plot and demodulate the burst
      plotframe2((r(burst_start:burst_end)))
      frame_number = (first_data_burst_frame_number + (n-1) + 4 * (m-1) + 10 * (k-1));
      rx_burst = demod_nb(r',burst_start);
      
      % Must store data from 4 burst before we have a complete message
      rx_data_matrix1(n,:)=DeMUX(rx_burst);
      %pause
    end

    % Avoid error messages if we broke out of the for loop
    if burst_end < L
      rx_enc=deinterleave( [ rx_data_matrix1 ; rx_data_matrix1 ] );
      [rx_block1,FLAG_SS,PARITY_CHK]=channel_dec_sacch(rx_enc);
      check_parity_sacch(rx_block1, PARITY_CHK);
      frame_number_mod_51 = mod(frame_number, 51)
      if frame_number_mod_51 == 5 
        fprintf(1,'Channel type = BCCH\n');
      else
        fprintf(1,'Channel type = CCCH\n');
      end
      view_oct(rx_block1)
      %pause
    end
  end  
end