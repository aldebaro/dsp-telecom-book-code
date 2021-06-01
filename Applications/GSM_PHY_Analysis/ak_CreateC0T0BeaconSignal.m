gsm_set; %set some variables
global syncBits %the SCH burst has a longer training sequence (64 bits) than the
global debugWithArtificialFile %use for debugging with pre-defined bursts
debugWithArtificialFile = 1;
maxNumOf51Multiframes = 3; %number of 51-frames multiframes
showPlots=1; %use 1 to show intermediate plots
outputFileName='./GSMSignalFiles/beacon.cfile';
samplesPerBurst=156.25*4; %625 = 156.25 bits/burst and oversampling = 4 (assumed here)
guardPeriodLengthMinus2bits=6.25*4; %25 = When oversampling is 4, modulator functions return I and Q with
%600 samples, which corresponds to 150 bits, not 148 bits for the
%burst. Then, the 8.25 bits guard period is only 6.25 bits here
guardPeriod=zeros(1,guardPeriodLengthMinus2bits); %25 samples for oversampling = 4

x=[]; %initialize signal array
frameNumber=0;
for multiframeNumber=1:maxNumOf51Multiframes
    for block=1:5
        %first generate data for the specific TS0 time-slot and
        %the for the other slots TS1 to TS7
        %% Add FB
        %the three tail bits before the 142 zeros, are also zero
        %hence, there are 3 + 142 + 3 zeros in total. 
        %Assuming the 3 tail bits and OSR=4, the first sample
        %of the 142 bits in the FB is sample 13, and with OSR=1,
        %it is sample 4
        [fb_tx_burst, I , Q] = gsm_mod_fb(Tb,OSR,BT);
        x=[x I+1j*Q guardPeriod];
        
        numberOfBursts=7; %generate data for time-slots other than TS0
        [signal,nb_tx_burst]=ak_generateNormalBursts(numberOfBursts,guardPeriod);
        x=[x signal]; %signal has 4375 samples = 7 * 625
        frameNumber=frameNumber+1;
        
        %% Add SB
        %The first SB starts
        %at sample 5001 = 8 * 625 + 1 samples. There are 3 tail and 39
        %info bits before the start of the SB training sequence,
        %which corresponds to 42*OSR=168 samples. Hence,
        %the training sequence starts at sample 5169.
        BSIC=[1 0 0 0 0 0];
        %19 bits are used to identify the frame number (FN) as follows:
        %=> 11 bits identify the superframe within the hyperframe (1 hyperframe = 2048 superframes)
        %=> 5 bits specify the multiframe within the superframe (1 superframe = 26 control multiframes)
        %=> 3 bits identify the control block within the control multiframe (1 control multiframe = 5 control blocks)
        %T1   = [ rx_block(24) rx_block(9:16) rx_block(1:2)] * [1 2 4 8 16 32 64 128 256 512 1024]';
        %T2   = rx_block(19:23) * [1 2 4 8 16]';
        %T3M   = [ rx_block(25) rx_block(17:18)] * [1 2 4]';
        data=zeros(1,25);
        data(3:8)=BSIC;
        data(25)=1;
        data(17)=1;
        data(18)=1;
        tx_data = ak_encodeSB(data);
        [sb_tx_burst, I, Q] = gsm_mod_sb(Tb,OSR,BT,tx_data,syncBits); %modulate a burst
        x=[x I+1j*Q guardPeriod];
        numberOfBursts=7; %generate data for time-slots other than TS0
        signal=ak_generateNormalBursts(numberOfBursts,guardPeriod);
        x=[x signal];
        
        frameNumber=frameNumber+1;
        
        %% Add BCCH or CCCH (8 frames that happen after SB)
        numberOfBursts=8; %generate data for time-slots other than TS0
        %multiply by 8 to take in account other time slots:
        signal=ak_generateNormalBursts(8*numberOfBursts,guardPeriod);
        x=[x signal];
        frameNumber=frameNumber+numberOfBursts;
    end
    %add idle (only zeros) in last frame of 51-frames multiframe
    %this cause abrupt transition and spectral leakage. A professional
    %implementation would make modulation with smooth transition
    %and power going down as a ramp
    x=[x zeros(1,samplesPerBurst)];
    numberOfBursts=7; %generate data for time-slots other than TS0
    signal=ak_generateNormalBursts(numberOfBursts,guardPeriod);
    x=[x signal];
    frameNumber=frameNumber+1;
end

write_complex_binary(outputFileName, x);
disp(['Wrote ' outputFileName])