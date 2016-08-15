function ak_drawlabels(marks,labels,xAxisLastValue)
% function ak_drawlabels(marks,labels,xAxisLastValue)
%Plots strings under the abcissa. Useful for indicating events in the
%waveform or displaying transcriptions.
%
%Example:
%t=0:0.01:0.5;
%plot(t,rand(size(t)));
%xAxisLastValue = 0.25;
%marks = [0.04 0.06; 0.13 0.2];
%labels = char('ix','b');
%ak_drawlabels(marks,labels,xAxisLastValue)

[lin1 col1]=size(marks);
[lin2 col2]=size(labels);

if lin1 ~= lin2
   error('Marks and labels have different number of lines');
end

numberOfLabels = lin1;

xlm = [0, xAxisLastValue];
set(gca,'Units','Pixels')
AxesXY =get(gca,'Position');

fac=AxesXY(3)/xlm(2);
Xoffset = AxesXY(1);

firstColor = [0 0 1];
secondColor = [0.5 0.5 0.5];
colors = [firstColor; secondColor];

for i=1:numberOfLabels
 xpos = round(Xoffset+marks(i,1)*fac);
 xwi= round((marks(i,2)-marks(i,1))*fac);   
 if xwi<=0
    xwi=2;
 end;
 colorIndex = rem(i,2) + 1;
 label = deblank(labels(i,:));
 lbUp(i)=uicontrol('Style','text','Position',[xpos 5 xwi 20 ],'BackGroundColor',...
    colors(colorIndex,:),'ForeGroundColor','y','HorizontalAlignment','center','String',label); 
end
