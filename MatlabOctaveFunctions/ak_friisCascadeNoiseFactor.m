function [Fcascade, Gcascade]=ak_friisCascadeNoiseFactor(F, G)
% function [Fcascade, Gcascade]=friisCascadeNoiseFactor(F, G)
%Implements Friis formula for noise factor, where F is the array
%with noise factors and G the gains, in linear scale.
Fcascade = F(1); Gcascade = G(1); %initialization
for i=2:length(F) %take in account all stages
    Fcascade = Fcascade + (F(i)-1)/Gcascade; %From Friis equation
    Gcascade = Gcascade*G(i); %update for next iteration
end