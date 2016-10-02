% This script adds the paths needed for the GSMsim package to 
% run correctly. If you change the structure of the directories
% within the GSMsim package then you need to edit this script.
% This script should be executed while standing in the directory
% GSMtop/config.
%
% AUTOR:    Arne Norre Ekstrøm / Jan H. Mikkelsen
% EMAIL:    aneks@kom.auc.dk / hmi@kom.auc.dk
%
% $Id: GSMsim_config.m,v 1.5 1998/02/12 11:00:32 aneks Exp $

% We should have this script in GSMtop/config, now go to GSMtop
cd .. ;

% Find out where GSMtop is located on the disk...
GSMtop=pwd ;

% Now that we have got the information we need for setting up the path,
% then lets set it up.
path(path,[ GSMtop '/config' ]);
path(path,[ GSMtop '/examples' ]);
path(path,[ GSMtop '/utils' ]);
path(path,[ GSMtop '/src/modulator' ]);
path(path,[ GSMtop '/src/demodulator' ]);

% Just to make this fool proof, re-enter the config directory
cd config ;