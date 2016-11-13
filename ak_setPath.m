%% Before using the code, it is important to set the PATH such that
% Matlab/Octave can find the files.
% Assuming you are at the folder Code that contains the subfolders of
% interest, then go to Matlab / Octave and run this script
addpath([pwd filesep 'MatlabOctaveFunctions'],'-end')
addpath([pwd filesep 'MatlabOctaveThirdPartyFunctions'],'-end')
addpath([pwd filesep 'MatlabOnlyThirdPartyFunctions'],'-end')
addpath([pwd filesep 'MatlabOctaveCodeSnippets'],'-end')
addpath([pwd filesep 'MatlabOctaveBookExamples'],'-end')
addpath([pwd filesep 'MatlabBookFigures'],'-end')
%It is more elegant to choose the one below, but it does not hurt
%to include both:
addpath([pwd filesep 'MatlabOnly'],'-end')
addpath([pwd filesep 'OctaveOnly'],'-end')
%to save the path
savepath