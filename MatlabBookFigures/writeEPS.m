function writeEPS(outputFileName, finalFormatting)
% function writeEPS(outputFileName, finalFormatting)
%write as EPS. If finalFormatOption is not used, do not format. If it is
%used, then increase the line width. Use option font12Only
%for increasing lines only.
if nargin == 1
    finalFormatting='wider'; %default is to make plots wider
end

if strcmp(finalFormatting, 'none')
    %do not do anything
else
    h=figure(1); %get handler, which is a "Figure" object
    if strcmp(finalFormatting, 'wider') %impose our format
        myFontSize = 12;
        %AK from http://www.mathworks.com/matlabcentral/newsreader/view_thread/12055
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
        error(['Format ' finalFormatting ' not supported. Want to use font12Only,none,legendInLatex ?']);
    end
end

%this is equivalent to
%print -depsc ../../Figures/outputFileName.eps
%pause
fullPathFileName = ['../../Figures/' outputFileName '.eps'];
disp(['Printing ' fullPathFileName]);
if 1
    %old style
    %from URL:
    %http://www.mathworks.com/access/helpdesk/help/techdoc/index.html?/access/helpdesk/help/techdoc/creating_plots/f3-124745.html
    %This example shows how to print or export your figure the same size it is
    %displayed on your screen.
    %Set the PaperPositionMode property to auto before printing the figure.
    %If later you want to print the figure at its original size, set
    %PaperPositionMode back to 'manual'.
    set(gcf, 'PaperPositionMode', 'auto'); %this is done in export_fig
    if 0
        print(gcf,'-depsc',fullPathFileName);
    else
        %to use CMYK, seee:
        %http://www.mathworks.com/help/matlab/creating_plots/changing-a-figures-settings.html#f3-99776
        %and
        %http://www.mathworks.com/support/solutions/en/data/1-7XCA91/index.html?product=ML&solution=1-7XCA91
        print(gcf,'-depsc','-cmyk',fullPathFileName);
    end
else
    %using the export_fig package:
    %http://sites.google.com/site/oliverwoodford/software/export_fig
    %Need to install: http://www.foolabs.com/xpdf/download.html
    set(gcf, 'Color', 'w');
    if 1 %for CMYK color space:
        eval(['export_fig ' fullPathFileName ' -painters -q100 -RGB -r600 -CMYK']);
    else %for gray color space (black and white figures)
        eval(['export_fig ' fullPathFileName ' -painters -q100 -RGB -r600 -gray']);
    end
end
