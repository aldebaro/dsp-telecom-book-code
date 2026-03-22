%% Get samples using fread and skipping header:
fp=fopen('c:/temp/myvoice.wav','rb'); %open for reading in binary
x=fread(fp,Inf,'int16'); %read all samples as signed 16-bits
fclose(fp);  %close the file
x(1:22)=[]; %eliminate the 44-bytes header of a Microsoft RIFF file
%% Now using readwav in folder MatlabOctaveThirdPartyFunctions:
[x2,Fs,wmode,fidx]=readwav('c:/temp/myvoice.wav','r'); % raw samples
b = fidx (7); % num of bits per sample
x2=double(x2); %convert integer to double for easier manipulation
isequal(x,x2) %result must be 1, indicating vectors are identical
%% Now using Matlab's audioread (not available in Octave):
%[x3, fs] = audioread('c:/temp/myvoice.wav', 'native');
%isequal(x,x3) %result must be 1, indicating vectors are identical