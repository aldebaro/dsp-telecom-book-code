function [optimalThresholds, BayesError]=...
    ak_MAPforTwoGaussians(mean1, standardDeviation1, ...
    prior1, mean2, standardDeviation2, prior2)
%function [optimalThresholds, BayesError]=...
%    ak_MAPforTwoGaussians(mean1, standardDeviation1, ...
%    prior1, mean2, standardDeviation2, prior2)
%Assuming two Gaussians and the MAP criterion, find the 
%thresholds for the optimal decision regions and the Bayes
%error (i.e., the minimum error probability). It is
%assumed that mean1 <= mean2. Also, when there is a single
%threshold, a value smaller than
%the threshold decides for the first symbol (Gaussian 1),
%otherwise it is Gaussian 2.

if (mean1 > mean2)
    error('mean1 must be less or equal mean2');
end

ohaveSameVariance = 0;
if (standardDeviation1 == standardDeviation2)
    ohaveSameVariance = 1;
end

[dsmallestPrior, minPrior] = min([prior1 prior2]);
%First case: degenerated, the same mean and variance
if (ohaveSameVariance && mean1 == mean2)
    %we assume that one class, the one with largest
    %prior would be arbitrarily chosen all times
    BayesError = dsmallestPrior;
    if (minPrior == 1) 
        optimalThresholds = -Inf; %always 2nd Gaussian
    else
        optimalThresholds = Inf; %always 1st Gaussian
    end
    return;
end

%Second case
if ohaveSameVariance && prior1 == 0.5 %uniform prior
    optimalThresholds=(mean1+mean2) / 2.0;
    prob = octave_normcdf(optimalThresholds, mean1, ...
        standardDeviation1);
    pe = 1 - prob;
    %note that the result above is equivalent to:
    %error1 = 0.5 * (1 - prob)
    %prob = octave_normcdf(x1,u2,s2)
    %error2 = 0.5 * prob
    %pe = error1+error2
    BayesError = pe;
    return;
end

%auxiliary variables:
v1 = standardDeviation1 * standardDeviation1; %variance 1
v2 = standardDeviation2 * standardDeviation2; %variance 2
b = 2*(v1*mean2-v2*mean1);
c = v2*(mean1 * mean1) - v1 * (mean2 * mean2) ...
    - 2 * v1 * v2 * log(standardDeviation2 * prior1 / ...
    (standardDeviation1 * prior2));

%3rd case: same variance but different priors
if ohaveSameVariance %but non-uniform prior
    optimalThresholds = -c/b;
    prob = octave_normcdf(optimalThresholds, mean1, ...
        standardDeviation1);
    error1 = prior1 * (1 - prob);
    prob = octave_normcdf(optimalThresholds, mean2, ...
        standardDeviation2);
    error2 = prior2 * prob;
    BayesError = error1+error2;
    return;
end

if (prior1 ~= prior2)
    %General case: Gaussians have different variances and
    %different priors. Need to calculate the Bayes error
    %taking in account that there are two thresholds.
    error('General case not implemented yet!');
end

%4th case: Gaussians have different variances but uniform
%priors. Solve second order equation
a = v2 - v1; %auxiliary variable
delta = sqrt(b*b-4.0*a*c);
if a>0 %a is positive so x2 is greater than x1    
    x1=(-b-delta)/(2.0*a);
    x2=(-b+delta)/(2.0*a);
else
    x1=(-b+delta)/(2.0*a);
    x2=(-b-delta)/(2.0*a);    
end

prob1 = octave_normcdf(x1, mean1, standardDeviation1);
prob2 = octave_normcdf(x2, mean1, standardDeviation1);

%double prob = normcdf([x1 x2],u1,s1);
%Assume same prior probability: 0.5
error1 = 0.5 * (1.0 - (prob2-prob1));

prob1 = octave_normcdf(x1, mean2, standardDeviation2);
prob2 = octave_normcdf(x2, mean2, standardDeviation2);
%prob = normcdf([x1 x2],u2,s2);
error2 = 0.5 * (prob2-prob1);
pe = error1 + error2;

optimalThresholds = [x1 x2];
BayesError = pe;
