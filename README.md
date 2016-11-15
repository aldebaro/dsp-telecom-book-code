# dsp-telecom-book-code

Source code for Aldebaro's book on DSP and digital communications. More information at http://aldebaro.ufpa.br/

# Installation

1) Execute Matlab or Octave

2) Using Matlab/Octave go to the "Code" folder (you should see subfolder such as Code\MatlabOctaveFunctions)

3) Run the script ak_setPath 

4) Use the command path to verify if the folders (MatlabOctaveFunctions and others) were properly added.

Alternatively, after download, you can manually set the path of Octave or Matlab to include the folders MatlabOctaveFunctions (with functions such as ak_psd.m)  MatlabOctaveThirdPartyFunctions (with mseq.m). For example, use something like the below in the beginning of your code:
addpath('../dsp-telecom-book-code/MatlabOctaveFunctions);
addpath('../dsp-telecom-book-code/MatlabOctaveThirdPartyFunctions);

# Note to Octave users

Besides "installing" the packages (that are called "toolboxes" in Matlab), Octave requires "loading" (enabling for usage) the packages that will be used. For example, having the "signal" package installed, to effectively use it, issue the command:

pkg load signal

# Credits
I tried to give credits to all third-party code I am using. In case I failed, please let me know and will I happily give proper credits.
