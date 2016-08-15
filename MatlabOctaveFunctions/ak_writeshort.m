function ak_writeshort(fileoutstring,matrixout)
% function ak_writeshort(fileoutstring,matrixout)

fid = fopen(fileoutstring,'wb');
matrixout = flipud(rot90(matrixout));
fwrite(fid,matrixout,'short');
fclose(fid);