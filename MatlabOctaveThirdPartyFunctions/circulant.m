function t = circulant(c)
%CIRCULANT -Circulant matrix.
%  C = circulant(c)
%
% CIRCULANT.m output a Circulant matrix C with its first column equal to the vector c.%
% input   c         VECTOR first column of the circulant matrix
%
% (written by L. Ling, Simon Fraser University, 1999)

   m = length(c);
   c = c(:);                               % build vector of user data

   cidx = (1:m)';
   ridx = 1:m;
   t = cidx(:,ones(m,1)) - ridx(ones(m,1),:);    
   t = mod(t,m)+1;                         % circulant subscripts
   t(:) = c(t);                            % actual data

