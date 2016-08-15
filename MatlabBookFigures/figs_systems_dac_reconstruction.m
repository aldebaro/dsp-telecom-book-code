%Show the effect of increasing the oversampling factor, and how it
%is difficult to feed a DAC with a critically-sampled signal
close all
figs_systems_showDACFilterEffect(25e3)
writeEPS('dacFilter25khz','font12Only')
figs_systems_showDACFilterEffect(80e3)
writeEPS('dacFilter80khz','font12Only')