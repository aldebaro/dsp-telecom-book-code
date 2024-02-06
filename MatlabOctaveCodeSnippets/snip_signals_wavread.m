fp=fopen('myvoice.wav','rb'); %open for reading in binary
x=fread(fp,Inf,'int16'); %read all samples as signed 16-bits
fclose(fp);  %close the file
x(1:22)=[]; %eliminate the 44-bytes header
[x2,Fs,wmode,fidx]=readwav('myvoice.wav','r'); % get raw samples
b = fidx (7); % num of bits per sample
x2=double(x2); %convert integer to double for easier manipulation
isequal(x,x2) %result is 1, indicating vectors are identical

