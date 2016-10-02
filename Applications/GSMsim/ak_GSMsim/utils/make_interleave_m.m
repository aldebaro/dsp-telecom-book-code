% MAKE-INTERLEAVE-M:
%           As the name indicates, this tiny matlab script does construction
%           of the interleave.m-function. 
%
% SYNTAX:   make_interleave_m
%
% INPUT:    None.
%
% OUTPUT:   To interleave.tmp
%
% WARNINGS: An existing file will be overwritten.
% 					
% AUTHOR:   Arne Norre Ekstrøm / Jan H. Mikkelsen
% EMAIL:    aneks@kom.auc.dk / hmi@kom.auc.dk
%
% $Id: make_interleave_m.m,v 1.4 1997/12/18 13:27:27 aneks Exp $

Blocks=1;
BitsInBurst=113;

out=fopen('interleave.tmp','w');

for T=0:3,
  for t=0:BitsInBurst,
    b=mod((57*mod(T,4)+t*32+196*mod(t,2)),456);
    B=floor((T-mod(b,8))/4);
    fprintf(out,'tx_data_matrix(%d,%d)=tx_enc%d(%d);\n',T+1,t+1,B+1,b+1);
  end
end
fclose(out);