function ak_add3dots()
% function ak_add3dots()
%add 3 dots '...' in the endpoints to indicate infinite duration signals
h=get(gca);

%did not work well
    XLim = h.XLim;
    delta = (XLim(2) - XLim(1))/10;
if delta > 1
    %make delta the amount of current tick. Assume ticks are numbers
    XLim = str2num(h.XTickLabel);
    delta = XLim(2) - XLim(1);
end

ypos = (h.YLim(2)+ 0.8*h.YLim(1))/2; %y position

%redefine axis
newAxis = axis;
newAxis(1)=newAxis(1)-delta;
newAxis(2)=newAxis(2)+delta;

%place text
text(newAxis(1)+delta/6, ypos, '...', 'FontSize',20)
text(newAxis(2)-delta+delta/6, ypos, '...', 'FontSize',20)

axis(newAxis)