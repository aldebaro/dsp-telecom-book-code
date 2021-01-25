fp=fopen('myvoice.wav','rb'); %open for reading in binary
x=fread(fp,Inf,'int16'); %read all samples as signed 16-bits
fclose(fp);  %close the file
x(1:22)=[]; %eliminate the 44-bytes header
[x2,Fs,b]=readwav('myvoice.wav','r');
x2=double(x2); %convert integer to double for easier manipulation
max(abs(x-x2)) %result is 0, indicating they are identical

