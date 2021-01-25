function writeEPS(outputFileName, finalFormatting)
% function writeEPS(outputFileName, finalFormatting)
% Write current figure as EPS file in folder Figures. Calls function
% ak_increaseFigureItems unless finalFormatting == 'none'.
% Default value of finalFormatting is 'wider'
% See ak_increaseFigureItems.
if nargin == 1
    finalFormatting='wider'; %default is to make plots wider
end
%drawnow %make sure figure is completed
%% Make figure items larger, if requested
if ~strcmp(finalFormatting, 'none')
    ak_increaseFigureItems(finalFormatting);
end

%% Print the EPS file
%this is equivalent to
%print -depsc ../../Figures/outputFileName.eps
%There are two options for the relative position of the current
%folder with respect to the output folder Figures
outputFolder='../../Figures/';
doesFolderExist=exist(outputFolder,'dir');
if doesFolderExist == 0
    outputFolder='../../../Figures/';
end

fullPathFileName = [outputFolder outputFileName '.eps'];
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
