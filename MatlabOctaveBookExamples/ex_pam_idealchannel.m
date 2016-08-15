fileHandler=fopen('myfile.bin','r'); %open in binary mode
if fileHandler==-1 %check if successful
    error('Error opening the Tx file! Does it exist?');
end
inputBytes=fread(fileHandler, inf, 'uchar'); %read bytes
fclose(fileHandler); %close the input file
b=4; %number of bits per symbol
M=2^b; %number of symbols
constel = -(M-1):2:(M-1); %create PAM constellation
%Use oversampling L=1, such that symbol rate = Fs
Fs=100; %sampling frequency in Hz
chunksTx = ak_sliceBytes(inputBytes, b); %"cut" bytes
symbols = constel(chunksTx+1); %get the Tx symbols
s = symbols; %oversampling=1, send the symbols themselves
r = s; %ideal channel: received signal = transmitted
[chunksRx, r_hat]=ak_pamdemod(r,M); %PAM demodulation
BER = ak_estimateBERFromBytes(chunksTx,chunksRx) %get BER
recoveredBytes = ak_unsliceBytes(chunksRx, b); %get bytes
fileHandler=fopen('received.bin','w');%open in binary mode
if fileHandler==-1 %check if successful
    error('Error opening the Rx file! Does it exist?');
end
fwrite(fileHandler, recoveredBytes, 'uchar'); %write file
fclose(fileHandler); %close the file with received bytes
