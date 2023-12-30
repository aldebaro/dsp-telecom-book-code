y=[14;50;32767;-32768;14;0]; %example, as column vector
writewav(y,11025,'somename.wav','16r') %write as 16-bits
z=readwav('somename.wav','r'); %avoid normalization
isequal(y,z) %should return true
% compare with double representation
yd=double(y); %convert from int16
yd=yd/max(abs(yd)); %normalize
zd=readwav('somename.wav','s'); %with normalization
isequal(yd,zd) %should return true