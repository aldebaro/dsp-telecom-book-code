%PDF2EPS  Convert a pdf file to eps format using pdftops
%
% Examples:
%   pdf2eps source dest
%
% This function converts a pdf file to eps format.
%
% This function requires that you have pdftops, from the Xpdf suite of
% functions, installed on your system. This can be downloaded from:
% http://www.foolabs.com/xpdf  
%
%IN:
%   source - filename of the source pdf file to convert. The filename is
%            assumed to already have the extension ".pdf".
%   dest - filename of the destination eps file. The filename is assumed to
%          already have the extension ".eps".

% Copyright (C) Oliver Woodford 2009

% $Id: pdf2eps.m,v 1.2 2009/04/19 21:48:42 ojw Exp $

function pdf2eps(source, dest)
% Construct the options string for pdftops
if ispc
    options = ['-q -paper match -pagecrop -eps -level2 "' source '" "' dest '"'];
else
    options = ['-q -paper match -eps -level2 "' source '" "' dest '"'];
end
% Convert to eps using pdftops
%AK will check the status to inform about errors
status = pdftops(options); %status should be 0 for normal operation
fid = fopen(dest, 'r+'); %check if file exists and can be read
if status~=0
    if fid == -1
        warning(['Could not create file ' dest]);
    end
    error(['Error running ghostscript with options: ' ...
        options]);
end
if fid == -1
    % Cannot open the file
    return
end
% Fix the DSC error created by pdftops
fgetl(fid); % Get the first line
str = fgetl(fid); % Get the second line
if strcmp(str(1:min(13, end)), '% Produced by')
    fseek(fid, -numel(str)-1, 'cof');
    fwrite(fid, '%'); % Turn ' ' into '%'
end
fclose(fid);
return

