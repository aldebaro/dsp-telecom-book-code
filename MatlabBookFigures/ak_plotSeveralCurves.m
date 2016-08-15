function ak_plotSeveralCurves(abscissa, matrix)
% function ak_plotSeveralCurves(abscissa, matrix)
%plot several curves

%AK: I thought there was a bug with plot. No need for this routine.

[m,n]=size(matrix);
if length(abscissa)~=m
    error('length(abscissa)~=m')
end

map=jet(n);
clf
hold on
for ii=1:n
    plot(abscissa,matrix(:,ii),'Color',map(ii,:));
    pause
end
hold off