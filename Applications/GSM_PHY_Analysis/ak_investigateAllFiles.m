%Select a folder and end it with slash (/ or \)
%folder='C:/gits/Latex/ak_dspbook/Code/Applications/GSM_PHY_Analysis/';
folder='C:/ak/Classes/Pos_PDSemFPGAeDSP/Projetos1aSemana/GSM_analysis/RawFiles/';
disp(['Folder: ' folder])
for fileNumber=1:8
    [r_original, information] = ak_getGSMDataFromFile(fileNumber,folder);
    sampleRate=information.sampleRate;
    ak_psd(r_original,sampleRate);
    %disp('Paused. Press <ENTER>'), pause
end