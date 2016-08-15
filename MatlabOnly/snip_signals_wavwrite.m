yd=double(y); %convert from int16 (y from getaudiodata)
yd=yd/max(abs(yd)); %need to normalize
wavwrite(yd,11025,16,'somename.wav') %write as 16-bits
z=wavread('somename.wav','native'); %avoid normalization

