%AK, June 2017: I edited the original function:
%function [] = GSMsim_demo_2(NumberOfBlocks,Lh,LogName)
%Now it is a script.
%
% GSMSIM_DEMO:
%           This demonstrates the function of the GSMsim
%           package, but now using channel coding. The script
%           ak_GSMsim_demo.m does not use channel coding. 
%           Use this file as a starting point for building 
%           your own simulations.
%
% SYNTAX:   GSMsim_demo_2(NumberOfBlocks,Lh,logname)
%
% INPUT:    NumberOfBlocks:  
%                   The number of GSM code blocks to process, a block
%                   corresponds to four GSM bursts.
%
%           Lh:     The length of the channel impulse response
%                   minus one.
%           LogName:
%                   The basename of the file to which the simulation log is
%                   to be written. The simulation log is handy for
%                   evaluating the convergence og a simulation.
%
% OUTPUT:   To a file called: logname.NumberOfBlocks.Lh
%           Simulation statistics are constantly echoed to the screen for
%           easy reference.
%
% WARNINGS: Do not expect this example to be more than exactly that, 
%           an example. This example is NOT scientifically correct.
% 					
% AUTHOR:   Arne Norre Ekstrøm / Jan H. Mikkelsen
% EMAIL:    aneks@kom.auc.dk / hmi@kom.auc.dk 
%
% $Id: GSMsim_demo_2.m,v 1.6 1998/10/01 10:18:47 hmi Exp $

disp('Recall that before running this script, you should have executed GSMsim_config.m in config folder');
exist(GSMtop,'dir');
% GSMsim_config.m should be executed while standing in the directory
% GSMtop/config

NumberOfBlocks = 40;
Lh =3; %channel dispersion, Lh>=4 imposes severe number of errors
LogName = 'simulation'; 

% This is an aid for the final screen report
%
tTotal=clock;

% Create the name of the log file for future reference.
%
LogFile=[LogName '_' num2str(NumberOfBlocks,'%9d') '_' ];
LogFile=[LogFile num2str(Lh,'%3d') '.gsmsim.txt'];

% Print header to the log file, abort if file already exist.
%
fid=fopen(LogFile,'r');
if fid~=-1
    fclose(fid); %close pointer to existing log file
    warning([LogFile ' already existed. It has been overwritten!'])
end
%if fid==-1
  LogFID=fopen(LogFile,'w');
  fprintf(LogFID,'%% GSMsim_demo_2 - simulation log.\n');
  fprintf(LogFID,'%%\n');
  fprintf(LogFID,'%% Settings:       NumberOfBlocks=%d\n',NumberOfBlocks);
  fprintf(LogFID,'%%                            Lh=%d\n',Lh);  
  fprintf(LogFID,'%%\n');
  fprintf(LogFID,'%% BlockNumber');
  fprintf(LogFID,'%% B_ERRS_Ia B_ERRS_Ib B_ERRS_II B_ERRS_II_CHEAT\n');
  fprintf(LogFID,'%%\n');
  fclose(LogFID);
%else
%  fclose(fid); %close pointer to existing log file
%  error('The logfile already exists, aborting simulation...');
%end

% There has, not yet, been observed any errors.
%
B_ERRS_Ia=0;
B_ERRS_Ib=0;
B_ERRS_II=0;
B_ERRS_II_CHEAT=0;

% gsm_set MUST BE RUN PRIOR TO ANY SIMULATIONS, SINCE IT DOES SETUP
% OF VALUES NEEDED FOR OPERATION OF THE PACKAGE.
%
gsm_set;

% PREPARE THE TABLES NEEDED BY THE VITERBI ALGORITHM.
%
[ SYMBOLS , PREVIOUS , NEXT , START , STOPS ] = viterbi_init(Lh);

% We need to initialize the interleaving routines, for that we need an so
% called first burst for the interleaver, this burst will not be fully
% received. Nor will bit errors be checked, hence there is no reason for
% encoding it...
%
tx_enc1=round(rand(1,456));

% Now we need a tx_data_matrix to start the deinterleaver thus get data
% for a burst. Bit errors will be checked for in this block.
%
tx_block2=data_gen(260);

% Do channel coding of data
%
tx_enc2=channel_enc(tx_block2);

% Interleave data
%
tx_data_matrix=interleave(tx_enc1,tx_enc2);

% Time goes by, and new become old, thus swap before entry of loop.
%
tx_enc1=tx_enc2;
tx_block1=tx_block2;

% Transmit and receive burst
%
rx_data_matrix1=tx_data_matrix;

% Sliding average time report aid.
% 
A_Loop=0;

for N=2:NumberOfBlocks+1,

  % Time report aid.
  % 
  t0=clock;
  
  % Get data for a new datablock, number two is the latest.
  %
  tx_block2=data_gen(260);  
 
  % Do channel coding of data
  %
  tx_enc2=channel_enc(tx_block2);

  % tx_data_matrix contains data for four bursts, generated from two blocks.
  %
  tx_data_matrix=interleave(tx_enc1,tx_enc2);

  for n=1:4,

    % THIS IS ALL THAT IS NEEDED FOR MODULATING A GSM BURST, IN THE FORMAT
    % USED IN GSMsim. THE CALL INCLUDES GENERATION AND MODULATTION OF DATA.
    % 
    [ tx_burst , I , Q ] = gsm_mod(Tb,OSR,BT,tx_data_matrix(n,:),TRAINING);
    
    % AT THIS POINT WE RUN THE CHANNEL SIMULATION. NOTE, THAT THE CHANNEL 
    % INCLUDES TRANSMITTER FORNT-END, AND RECEIVER FRONT-END. THE CHANNEL
    % SELECTION IS BY NATURE INCLUDED IN THE RECEIVER FRONT-END.
    % THE CHANNEL SIMULATOR INCLUDED IN THE GSMsim PACKAGE ONLY ADDS
    % NOISE, AND SHOULD _NOT_ BE USED FOR SCIENTIFIC PURPOSES.
    %
    r=channel_simulator(I,Q,OSR);

    % RUN THE MATCHED FILTER, IT IS RESPONSIBLE FOR FILTERING SYNCRONIZATION 
    % AND RETRIEVAL OF THE CHANNEL CHARACTERISTICS.
    % 
    [Y, Rhh] = ak_mafi(r,Lh,T_SEQ,OSR);
    
    % HAVING PREPARED THE PRECALCULATABLE PART OF THE VITERBI
    % ALGORITHM, IT IS CALLED PASSING THE OBTAINED INFORMATION ALONG WITH
    % THE RECEIVED SIGNAL, AND THE ESTIMATED AUTOCORRELATION FUNCTION.
    %
    rx_burst = viterbi_detector(SYMBOLS,NEXT,PREVIOUS,START,STOPS,Y,Rhh);
    
    % RUN THE DeMUX
    %
    rx_data_matrix2(n,:)=DeMUX(rx_burst);
  
  end

  % This is for bypassing the channel, uncomment to use
  %
  % rx_data_matrix2=tx_data_matrix;
  
  % A block is regenerated using eight bursts.
  %
  rx_enc=deinterleave( [ rx_data_matrix1 ; rx_data_matrix2 ] );

  % A good cheat/trick is to use all the encoded bits for estimating a type
  % II BER. This estimate is 100% statistically correct!!!
  %
  B_ERRS_II_CHEAT_NEW=sum(xor(tx_enc1,rx_enc));
  
  % Do channel decoding
  %
  rx_block=channel_dec(rx_enc);
  
  % Count errors
  %
  B_ERRS_ALL=xor(rx_block,tx_block1);
  B_ERRS_Ia_NEW=sum(B_ERRS_ALL(1:50));
  B_ERRS_Ib_NEW=sum(B_ERRS_ALL(51:182));
  B_ERRS_II_NEW=sum(B_ERRS_ALL(183:260));
  
  % Update the log file.
  %
  LogFID=fopen(LogFile,'a');
  fprintf(LogFID,'%d %d ',N-1,B_ERRS_Ia_NEW);
  fprintf(LogFID,'%d %d ',B_ERRS_Ib_NEW,B_ERRS_II_NEW);
  fprintf(LogFID,'%d\n',B_ERRS_II_CHEAT_NEW);
  fclose(LogFID);

  % Sum the errors
  %
  B_ERRS_Ia=B_ERRS_Ia+B_ERRS_Ia_NEW;
  B_ERRS_Ib=B_ERRS_Ib+B_ERRS_Ib_NEW;
  B_ERRS_II=B_ERRS_II+B_ERRS_II_NEW;
  B_ERRS_II_CHEAT=B_ERRS_II_CHEAT+B_ERRS_II_CHEAT_NEW;
  
  % Time goes by, and new become old, thus swap for next loop.
  %
  rx_data_matrix1=rx_data_matrix2;
  tx_enc1=tx_enc2;
  tx_block1=tx_block2;

  % Find the loop time
  % 
  elapsed=etime(clock,t0);

  % Find average loop time
  % 
  A_Loop=(A_Loop+elapsed)/2;

  % FIND REMAINING TIME
  % 
  Remain = (NumberOfBlocks+1-N)*A_Loop;

  % UPDATE THE DISPLAY
  % 
  fprintf(1,'\r');
  fprintf(1,'Block: %d, Average Block Time: %2.1f seconds',N-1,A_Loop);
  fprintf(1,', Remaining: %2.1f seconds ',Remain);

end

Ttime=etime(clock,tTotal);
BURSTS=NumberOfBlocks*4;

% Find BER.
%
TypeIaBits=NumberOfBlocks*50;
TypeIaBER=100*B_ERRS_Ia/TypeIaBits;
TypeIbBits=NumberOfBlocks*132;
TypeIbBER=100*B_ERRS_Ib/TypeIbBits;
TypeIIBits=NumberOfBlocks*78;
TypeIIBER=100*B_ERRS_II/TypeIIBits;
TypeIIBitsCHEAT=NumberOfBlocks*456;
TypeIIBER_CHEAT=100*B_ERRS_II_CHEAT/TypeIIBitsCHEAT;

fprintf(1,'\n%d Bursts processed in %6.1f Seconds.\n',BURSTS,Ttime);
fprintf(1,'Used %2.1f seconds per burst\n',Ttime/BURSTS);
fprintf(1,'\n');
fprintf(1,'Type Ia BER: %3.2f\n',TypeIaBER);
fprintf(1,'Type Ib BER: %3.2f\n',TypeIbBER);
fprintf(1,'Type II BER: %3.2f\n',TypeIIBER);
fprintf(1,'Type II BER-CHEAT: %3.2f\n',TypeIIBER_CHEAT);