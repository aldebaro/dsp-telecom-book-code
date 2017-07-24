function check_parity_sacch(rx_block, PARITY_CHK)
% function check_parity_sacch(rx_block, PARITY_CHK)
%AK perform block decoding
g = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1];
d = [rx_block PARITY_CHK];
[q,re] = deconv(d,g);

L = length(re);
out = abs(re(L-39:L)); %take 40 integer values
checkSum=sum(mod(out,2)); %check how many are odd numbers
if checkSum == 40
    disp('Checksum correct!');
else
    disp(['Checksum error (not 40, but ' num2str(checkSum) ')']);
end

if 0 %this is the old code, kind of weird
    for n = 1:length(out),
        if ceil(out(n)/2) ~= floor(out(n)/2)
            out(n) = 1;
        else
            out(n) = 0;
        end
    end
    if sum(out) ~= checkSum %tested and they are the same values
        error('sum(out) ~= checkSum');
    end
end
