%Note: within each GSM Frame there are 8 Timeslots of 576.92 ?s
%each (per timeslot) (577 ?s in round numbers).
%folder='C:/gits/Latex/ak_dspbook/Code/Applications/GSM_PHY_Analysis/GSMSignalFiles/';
burstDurationInms=576.92e-3; %in ms

[r_original, information] = ak_getGSMDataFromFile(fileNumber,folder);
ak_step1a; %obtain the filtered signal r

%decimate:
%Do not have for BT=0.3 but for BT=0.25, one has 99% of power at
%0.86 Rsym and 99.9 at 1.09 Rsym and 99.99% at 1.37 Rsym
desiredBandwidth=1.5*SymbolRate;
[Interpolation,Decimation]=rat(desiredBandwidth/SampleRate);
r = resample(r,Interpolation,Decimation); %t is at symbol rate
r=r(58:end); %take out transient
newFs = Interpolation*SampleRate/Decimation;
disp(['New sampling frequency: ' num2str(newFs)]);
samplingFrequency=newFs;
if 1 %Mathwork's specgram syntax
    nfft=1024;
    HanningWindowLength=190;
    noverlap=0; %HanningWindowLength-40;
    thresholdIndB=30;
    preemphasisCoefficient=0;
    verbosity=1;
    [b,f,t]=ak_specgramOriginalSyntax(r,nfft,...
        samplingFrequency,HanningWindowLength,noverlap,thresholdIndB,...
        preemphasisCoefficient, verbosity);
else %another kind of syntax (from ak_specgram)
    filterBWInHz=5000;
    windowShiftInms=burstDurationInms/4;
    thresholdIndB=40;
    preemphasisCoefficient=0;
    
    [b,f,t]=ak_specgram(r,filterBWInHz,...
        samplingFrequency,windowShiftInms,thresholdIndB,...
        preemphasisCoefficient);
end
figure(1)
imagesc(t*1000,f/1000,b);axis xy; colormap(jet)
xlabel('miliseconds'); ylabel('kHz');
colorbar
disp(['burstDurationInms: ' num2str(burstDurationInms)]);
