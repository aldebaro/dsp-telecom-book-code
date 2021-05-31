%% Using only K=2 tones, show how the rate varies with the
%power allocation. Could also show for K=3 assuming that
%the modem would use its total power, such that:
%P3 = Pmax - P1 - P2
clear all
close all
format long %show numbers as 15-digit scaled
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0 %pick channel 1 or 2
    Gk1 = 1e-3; %good subchannel
    Gk2 = 1e-6; %bad subchannel, but the power is split evenly
else
    Gk1 = 1e-1; %good subchannel
    Gk2 = 1e-10; %bad subchannel, allocate more power to subchannel 1
end
%ADSL has maximum power=110 mW, which gives 110m/256 ~= 4.3e-4 W per
%tone in this case. Because this simulation adopts K=2 tones, I will
%assume the total power to be 2*4.3e-4=8.6e-4~=1 mW, which is 0 dBm.
deltaf = 4.13125e3; %ADSL frequency spacing
symbolRate = 4000; %just to help calculating rate in bps
p_max = 1e-3; %maximum power in Watts

%Assume -140 dBm/Hz as background noise (corresponds to 1e-17 W)
%because 10*log10(1e-17/1e-3) = -140 dBm
noise_power = 1e-17 * deltaf; %should be / instead of * ?

%Create a grid of power values in dB domain, not linear
%adopt the maximum level as the total power such that one tone can
%get all the total power
max_power_dBmHz = 10*log10(p_max/1e-3);
min_power_dBmHz = max_power_dBmHz-50; %50 dB below maximum

n_power_levels  = 1000; %controls the grid used for simulation
%reserve one level to 0 Watts, so use n_power_levels-1
%use linear spacing in dB domain
delta_s=linspace(min_power_dBmHz,max_power_dBmHz,n_power_levels-2);
%convert to Watts: dBm = 10 log10 (W/1e-3) and pre-append 0 Watts and
%also include half of p_max
delta_s = [0 p_max/2 (1e-3 * (10.^ (delta_s/10)))];
delta_s = sort(delta_s); %because of the inclusion of p_max/2
%correct numerical errors
delta_s(end) = p_max;

%% Create the grid
[pk1,pk2] = meshgrid(delta_s, p_max-delta_s);
pk2=pk2'; %Trick to always have pk1 + pk2 = p_max in the grid

%assume both tones can transmit QAM (no need for PAM)
bitsk1 = log2(1 + (pk1*Gk1)/noise_power);
bitsk2 = log2(1 + (pk2*Gk2)/noise_power);

rate = symbolRate * (bitsk1 + bitsk2); %rate in bps

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
meshc(pk1*1e3,pk2*1e3,rate*1e-3); %properly organize powers and rate
xlabel('X: power for tone k=0 (mW)')
ylabel('Y: power for tone k=1 (mW)')
zlabel('Rate (kbps)')
%colorbar
view(axes1,[-103.439226519337 22.2106846926689]);
axis tight; hold on
grid

%find maximum
maxRate = max(rate(:));
[maxndx1,maxndx2] = find (rate == maxRate, 1, 'first');
bestpk1 = pk1(maxndx1,maxndx2);
bestpk2 = pk2(maxndx1,maxndx2);
maxRate

bitsk1 = log2(1 + (bestpk1*Gk1)/noise_power)
bitsk2 = log2(1 + (bestpk2*Gk2)/noise_power)
symbolRate * (bitsk1 + bitsk2) %should coincide with maxRate

handler = plot3(bestpk1*1e3,bestpk2*1e3,maxRate*1e-3,'rh','markersize',16);
makedatatip(handler,[1]); %there is only one point in plot3
%writeEPS('convexity2Tones','font12Only');
writeEPS('convexity2Tones','none');
