maxNumOfFrames = 200; %number of frames
showPlots=1;
gsm_set; %set some variables
outputFileName='./GSMSignalFiles/beacon.cfile';
samplesPerBurst=600; %for oversampling = 4 (assumed here)
%x=zeros(1,N); %pre-allocate
%the SCH burst has a longer training sequence (64 bits) than the
%used in normal bursts (26 bits):
SB_TRAINING = [1 0 1 1 1 0 0 1 0 1 1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 1 1 1 1 0 0 1 0 1 1 0 1 0 1 0 0 0 1 0 1 0 1 1 1 0 1 1 0 0 0 0 1 1 0 1 1];                                

x=[];
for frameNumber=1:maxNumOfFrames;
    frameNumberMod51 = mod(frameNumber, 51);
    if frameNumberMod51 == 50
        %add idle
        x=[x zeros(1,samplesPerBurst)];
    elseif mod(frameNumber, 10)==0
        %add FB
        [burst, I , Q] = gsm_mod_fb(Tb,OSR,BT);
        x=[x I+1j*Q];
        frameNumber=frameNumber+1;
        %add SB
        tx_data = data_gen(2*39); %randomly generate a burst
        [burst, I, Q] = gsm_mod_sb(Tb,OSR,BT,tx_data,SB_TRAINING); %modulate a burst
        x=[x I+1j*Q];
    else
        %normal
        tx_data = data_gen(INIT_L); %randomly generate a burst
        [burst, I, Q] = gsm_mod(Tb,OSR,BT,tx_data,TRAINING); %modulate a burst
        x=[x I+1j*Q];
    end
    for i=1:7 %generate data for TS1 to TS7
        %normal
        tx_data = data_gen(INIT_L); %randomly generate a burst
        [burst, I, Q] = gsm_mod(Tb,OSR,BT,tx_data,TRAINING); %modulate a burst        
        x=[x I+1j*Q];
    end    
    frameNumber=frameNumber+1;
end
write_complex_binary(outputFileName, x);
disp(['Wrote ' outputFileName])