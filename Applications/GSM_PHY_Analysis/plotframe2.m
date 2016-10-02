function plotframe2(r)

clf
L = length(r);
a = angle(r);
da = angle(r(1:L-1) .* conj(r(2:L)));
sa = cumsum(da);

subplot(2,2,1);
plot(abs(r));
title('Magnitude');

subplot(2,2,2);
plot(sa);
%axis([250 350 min(sa(250:350)) max(sa(250:350))]);
title('Phase');

subplot(2,1,2);
plot(da)
%axis([250 350 -2 2]);
title('Phase difference');

