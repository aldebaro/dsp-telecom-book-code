% MAKE-DEINTERLEAVE-M:
%           As the name indicates, this tiny matlab script does construction
%           of the deinterleave.m-function. 
%
% SYNTAX:   make_deinterleave_m
%
% INPUT:    None.
%
% OUTPUT:   To deinterleave.tmp
%
% WARNINGS: An existing file will be overwritten.
% 					
% AUTHOR:   Arne Norre Ekstrøm / Jan H. Mikkelsen
% EMAIL:    aneks@kom.auc.dk / hmi@kom.auc.dk
%
% $Id: make_deinterleave_m.m,v 1.4 1997/12/18 13:26:54 aneks Exp $

BitsInBlock=455;

out=fopen('deinterleave.tmp','w');

B=0;

for b=0:BitsInBlock,
  R=4*B+mod(b,8);
  r=2*mod((49*b),57)+floor(mod(b,8)/4);
  fprintf(out,'rx_enc(%d)=rx_data_matrix(%d,%d);\n',b+1,R+1,r+1);
end

fclose(out);