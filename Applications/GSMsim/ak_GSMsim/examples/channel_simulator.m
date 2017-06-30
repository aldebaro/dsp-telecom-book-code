function [ r, snrdB ] = channel_simulator(I,Q,OSR)
% CHANNEL_SIMULATOR:
%           This function is intended as an skeleton for channel
%           simulator implementations, and is not to be considderd
%           as an actual channel simulator. It does however provide
%           a mean for making the GSMsim package produce detection
%           errors. Substitute this function with userdefined
%           functions.
%
% SYNTAX:   channel_simulator(I,Q,OSR)
%
% INPUT:    I:      The inphase signal as produced by the modulator.
%           Q:      The quadrature signal as it is produced by the
%                   modulator .
%           OSR:    The over sampling ratio, defined as Fs/Rsym. This
%                   parameter is not used in the incuded channel_simulator
%                   function, but is passed to the function for future
%                   use.
%
% OUTPUT:   r:      The received signal, as predicted by the channel
%                   simulator.
%
% WARNINGS: Do not use this function for scientific purposes.
%
% AUTHOR:   Jan H. Mikkelsen / Arne Norre Ekstrøm
% EMAIL:    hmi@kom.auc.dk / aneks@kom.auc.dk
%
% $Id: channel_simulator.m,v 1.6 1998/02/12 10:56:13 aneks Exp $

% THE CHANNEL SIMULATOR INCLUDED IN THE GSMsim PACKAGE ONLY ADD
% NOISE, AND SHOULD _NOT_ BE USED FOR SCIENTIFIC PURPOSES.
%
% SUBSTITUTE THE NEXT LINES WITH A LINE CONTAINING A CHANNEL SIMULATION.
% HERE WE SIMPLY ADD NOISE OF VARIANCE Var TO THE MODULATED SIGNAL. NOTE
% THAT THIS NOISE IS ONLY BANDLIMITED BY THE SAMPLERATE.
%
r= I + 1j*Q; %noiseless signal
%b=[-4 20]; r=conv(r,b);
signalPower = mean(abs(r).^2);

Var=0.02; %noise power per dimension
FACTOR=sqrt(Var);
samples=length(r);
random=randn(1,2*samples);
noise = random(1:samples).*FACTOR + ...
    random(samples+1:2*samples).*FACTOR.*1j;
noisePower = mean(abs(noise).^2); %approximately 2 Var
r= r + noise; %add noise
snrdB = 10*log10(signalPower/noisePower);