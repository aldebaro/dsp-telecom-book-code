RFfreq=1400; %RF frequency of interest (carrier)
IFfreq=455; %intermediate frequency, assumed: IFfreq < RFfreq
LOh=RFfreq+IFfreq %high-side injection LO frequency
LOl=RFfreq-IFfreq  %low-side injection LO frequency
IMh=RFfreq+2*IFfreq %image freq. for high-side (or, IMh=LOh+IFfreq)
IMl=RFfreq-2*IFfreq %image for low (or, alternatively,IMl=LOl-IFfreq)