function [signal, lastBurst]=ak_generateNormalBursts(numberOfBursts,guardPeriod)
global Tb OSR BT TRAINING INIT_L
global debugWithArtificialFile
signal=[];
for i=1:numberOfBursts
    if debugWithArtificialFile==1 
        %for debugging purposes, generate fixed pattern
        tx_data = zeros(1,INIT_L);
        tx_data(1:5:end)=1;
    else
        tx_data = data_gen(INIT_L); %randomly generate a burst        
    end
    [lastBurst, I, Q] = gsm_mod(Tb,OSR,BT,tx_data,TRAINING); %modulate a burst
    signal=[signal I+1j*Q guardPeriod];
end