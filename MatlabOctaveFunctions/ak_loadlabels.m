function [marks, labels] = ak_loadlabels(labelsFileName)
% function [marks, labels] = ak_loadlabels(labelsFileName)
%Reads text file with transcriptions.

fp =fopen(labelsFileName,'r');

index = 1;
labels = '';
while 1
   [endp,cnt]=fscanf(fp,'%d %d',2);	
   if cnt ~=2
      break;
   else
      lab = fscanf(fp,'%s',1);
      marks(index,1) = endp(1);
      marks(index,2) = endp(2);
      labels = char(labels,lab);
      index = index + 1;
   end
end
%added blank line, so delete it
labels(1,:)=[];
fclose(fp);