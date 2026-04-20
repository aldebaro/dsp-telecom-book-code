# Code for the book "Digital Signal Processing Using Python, Matlab, and Octave"

Source code for Aldebaro's book on DSP.
The printed version can be found at Amazon: https://www.amazon.com/dp/6501609135/.
The online version is available at https://ai6g.org/books/dsp/ak_dsp_book.html.
Besides DSP, there is also code for digital communications.

# Python

Most of our teaching and research activities are now conducted in Python. While the printed version of the book emphasizes MATLAB due to its conciseness, equivalent Python implementations are readily available online or can be generated with modern AI/LLM tools. Accordingly, the primary emphasis has shifted to Jupyter notebooks in Python, which provide an effective and interactive environment for learning digital signal processing (DSP).

# Extra Python code

The following projects complement the code provided in this repository:

https://github.com/aldebaro/dsp-projects - DSP projects

https://github.com/lasseufpa/lasse-py - useful Python modules


# Installation of Matlab / Octave code

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
I tried to give credits to all third-party code I am using. In case I failed, please let me know and I will happily give proper credits.
