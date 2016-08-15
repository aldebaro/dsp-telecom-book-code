function ak_plotEyeDiagram(firstSample,increment,x)
% function ak_plotEyeDiagram(firstSample,increment,x)
hold on;
h=gcf; %get handler, which is a "Figure" object
lastSample = length(x) - (increment-1) - firstSample;
abscissa = 0:increment-1;
%skip first segment
for i=firstSample+increment:increment:lastSample
    %plot(abscissa,x(i:i+increment-1),'bx-');
    plot(abscissa,x(i:i+increment-1),'b-');
    %pause
end
%plot first segment in red
i=firstSample;
%plot(abscissa,x(i:i+increment-1),'ro-');
plot(abscissa,x(i:i+increment-1),'r-');
linesHandle = findobj(h,'Type','line'); %check for lines
lineWidth=1;
set(linesHandle(1),'LineWidth',lineWidth);
hold off;
ylabel('amplitude');
%xlabel('sample index (count)');
xlabel('sample')
set(gca,'Xticklabel',[])

