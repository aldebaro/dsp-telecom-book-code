yd=double(y); %convert from int16
yd=yd/max(abs(yd)); %normalize
writewav(yd,11025,'somename.wav','16r') %write as 16-bits
z=readwav('somename.wav','r'); %avoid normalization

