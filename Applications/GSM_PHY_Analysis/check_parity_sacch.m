function check_parity_sacch(rx_block, PARITY_CHK)

% Parity check 
% I have no idea what this does, but all bits in out() are 1 and that must
% mean something? I assume it means the parity is ok.

g = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1];
d = [rx_block PARITY_CHK];
[q,re] = deconv(d,g);

L = length(re);
out = abs(re(L-39:L));
for n = 1:length(out),
  if ceil(out(n)/2) ~= floor(out(n)/2)
    out(n) = 1;
  else
    out(n) = 0;
  end
end


if sum(out) == 40 
    fprintf(1,'\nChecksum correct!\n');
else
    fprintf(1,'\nChecksum error!\n');
end