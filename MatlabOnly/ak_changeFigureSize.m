function ak_changeFigureSize(width_factor, height_factor)
% function ak_changeFigureSize(width_factor, height_factor)
%Change figure size by the factors width_factor and height_factor,
%and position figure in center of screen.

%From https://www.cs.cornell.edu/courses/cs100m/2007fa/Graphics/Position.pdf
%set(gcf,'position',[a b H W])
%places the lower left corner of an H-by-W figure window at (a, b).

pos=get(gcf, 'Position'); %get figure's position on screen
pos(3)=floor(pos(3)*width_factor); %adjust the width
pos(4)=floor(pos(4)*height_factor); %adjust the height
set(gcf,'Position',pos);
movegui(gcf,'center')