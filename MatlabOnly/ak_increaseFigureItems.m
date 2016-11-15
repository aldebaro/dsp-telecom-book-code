function ak_increaseFigureItems(finalFormatting)
% function ak_increaseFigureItems(outputFileName, finalFormatting)
% Increase the size of items in a figure, such as font, line width,
% etc. The optins for the string finalFormatOption allows
%    ==> 'font12Only': increase only the fonts, not line widths
%    ==> 'wider': default, increases both
%    ==> 'legendInLatex': also increases legend interpreted in Latex
%To understand the last option, please note that using Latex in 
%legends is tricky. From https://www.mathworks.com/matlabcentral/answers/60101-warning-unable-to-interpret-tex-string
%generate a legend interpreted with Latex:
%plot(1:10); hold on; plot(10:-1:1,'r') %get two plots
%%create a temporary legend (it will be overwritten by next command)
%[legend_h,object_h,plot_h,text_strings] = ...
%  legend('X_will_be_overwritten','Y_will_be_overwritten','Location','Best');
%set(legend_h, 'Interpreter', 'latex', 'string', {'${\hat X}$','${\log_{10}e^3}$'});
%Using ak_increaseFigureItems would not increase the legend font
%because it is in Latex. But the fonts are enlarged with
%ak_increaseFigureItems('legendInLatex')
if nargin == 0
    finalFormatting='wider'; %default is to make plots wider
end

h=figure(1); %get handler, which is a "Figure" object
if strcmp(finalFormatting, 'wider') %impose our format
    myFontSize = 12;
    %From http://www.mathworks.com/matlabcentral/newsreader/view_thread/12055
    all_text = findall(gcf, 'Type', 'Text');
    set(all_text, 'FontSize', myFontSize);
    linesHandle = findobj(h,'Type','line'); %check for lines
    for i=1:length(linesHandle)
        set(linesHandle(i),'LineWidth',3);
        set(linesHandle(i),'MarkerSize',myFontSize-2);
    end
    axesHandle = findobj(h,'Type','axes'); %check for axes
    for i=1:length(axesHandle)
        set(axesHandle(i),'FontSize',myFontSize); %this changes the ticks, but not the labels
        xlHandle = get(axesHandle(i),'xlabel');
        set(xlHandle,'FontSize',myFontSize);
        %myString = get(xlHandle,'string')
        ylHandle = get(axesHandle(i),'ylabel');
        set(ylHandle,'FontSize',myFontSize);
    end
    %old way:
    %child_handles = get(h,'Children'); %children shold be a "Axes" object
    %for i=1:length(child_handles) %for all children (in case of subplot)
    %    set(child_handles(i),'FontSize',12); %increase font in axes
    %    grandchild_handles = get(child_handles(i),'Children'); %"Lineseries" objects
    %    set(grandchild_handles,'LineWidth',3);
    %end
elseif strcmp(finalFormatting, 'font12Only') %increase font, but not lines
    %AK from http://www.mathworks.com/matlabcentral/newsreader/view_thread/12055
    all_text = findall(gcf, 'Type', 'Text');
    myFontSize = 12;
    set(all_text, 'FontSize', myFontSize);
    axesHandle = findobj(h,'Type','axes'); %check for axes
    for i=1:length(axesHandle)
        set(axesHandle(i),'FontSize',myFontSize); %this changes the ticks, but not the labels
        xlHandle = get(axesHandle(i),'xlabel');
        set(xlHandle,'FontSize',myFontSize);
        %myString = get(xlHandle,'string')
        ylHandle = get(axesHandle(i),'ylabel');
        set(ylHandle,'FontSize',myFontSize);
    end
elseif strcmp(finalFormatting, 'legendInLatex') %impose other format
    myFontSize = 12;
    latexFontSize = 14;
    linesHandle = findobj(h,'Type','line'); %check for lines
    for i=1:length(linesHandle)
        set(linesHandle(i),'LineWidth',3);
        set(linesHandle(i),'MarkerSize',myFontSize-2);
    end
    axesHandle = findobj(h,'Type','axes'); %check for axes
    for i=1:length(axesHandle)
        set(axesHandle(i),'FontSize',myFontSize); %this changes the ticks, but not the labels
        xlHandle = get(axesHandle(i),'xlabel');
        set(xlHandle,'FontSize',myFontSize);
        %myString = get(xlHandle,'string')
        ylHandle = get(axesHandle(i),'ylabel');
        set(ylHandle,'FontSize',myFontSize);
    end
    legendHandle = legend; %get handler to legends
    if isempty(legendHandle)
        warning('Could not find a legend, but was instructed to increase its font size');
    else
        set(legendHandle,'FontSize',latexFontSize);
    end
    %old way:
    %child_handles = get(h,'Children'); %children shold be a "Axes" object
    %for i=1:length(child_handles) %for all children (in case of subplot)
    %    set(child_handles(i),'FontSize',12); %increase font in axes
    %    grandchild_handles = get(child_handles(i),'Children'); %"Lineseries" objects
    %    set(grandchild_handles,'LineWidth',3);
    %end
elseif strcmp(finalFormatting, 'somethingNew') %impose other format
    %to do
else
    error(['Format ' finalFormatting ' not supported. Want to use wider,font12Only,legendInLatex ?']);
end
