function check_parity_sacch(rx_block, PARITY_CHK)

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
    disp('Checksum correct!');
else
    disp(['Checksum error (not 40, but ' num2str(sum(out)) ')']);
end