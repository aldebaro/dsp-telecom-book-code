function out = ak_readshort(in,rows,cols)
% function out = ak_readshort(in,rows,cols)
fid = fopen(in,'r');
out = fread(fid,[rows,cols],'short');
out = flipud(rot90(out));
fclose(fid);