To use GSMsim, you need to first execute the script GSMsim_config.m which is in folder "config".
After that, you can go, for example, to folder "examples" and execute ak_GSMsim_demo.m

For example, assuming you installed things at c:\gits\Latex\ak_dspbook\Code\Applications\GSMsim\ak_GSMsim
and the ak_GSMsim folder has the following contents:
11/11/2016  12:09    <DIR>          config
11/11/2016  12:09    <DIR>          examples
11/11/2016  12:09    <DIR>          src
11/11/2016  12:09    <DIR>          utils

Then, from an Octave or Matlab prompt and within ak_GSMsim folder, issue the commands:
cd config
GSMsim_config.m
cd ../examples/
ak_GSMsim_demo.m
