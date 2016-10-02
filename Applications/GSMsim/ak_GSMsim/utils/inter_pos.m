% INTER_POS:
%           Interpos does calculation of where a bit from a informationblock
%           must go if tou ask the GSM ETSI standard.
%
% SYNTAX:   inter_pos
%
% INPUT:    None.
%
% OUTPUT:   To GSMMapping.txt.
%
% WARNINGS: An existing file will be overwritten.
% 					
% AUTHOR:   Arne Norre Ekstrøm / Jan H. Mikkelsen
% EMAIL:    aneks@kom.auc.dk / hmi@kom.auc.dk
%
% $Id: inter_pos.m,v 1.1 1997/11/12 11:02:56 aneks Exp $

tTotal=clock;
Blocks=1;
BitsInBlock=455;

BlErr=0;
BiErr=0;

out=fopen('GSMMapping.txt','w');
fprintf(out,'Mapping Table For GSM INTERLEAVING\n\n');

for N=0:Blocks,
  fprintf(1,'%d\r',N)
  for k=0:BitsInBlock,
    OB=4*N+mod(k,8);
    OP=2*mod((49*k),57)+floor(mod(k,8)/4);
    RP=mod((57*mod(OB,4)+OP*32+196*mod(OP,2)),456);
    RB=floor((OB-mod(RP,8))/4);
    fprintf(out,'In: %3d;%3d --> Out: %3d;%3d --> Redo: %3d;%3d\n',N,k,OB,OP,RB,RP);
  end
end
fclose(out);

Ttime=etime(clock,tTotal);

fprintf(1,'BitErrors: %d\n',BiErr);
fprintf(1,'BlockErrors: %d\n',BlErr);

TBurst=Ttime/(Blocks*4);

fprintf(1,'\nUsed approximately %2.2f seconds per Burst.\n',TBurst);





