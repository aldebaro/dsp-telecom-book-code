% Receiver source for GSMsim
% Created at Aalborg University in July 1997.
% Authors: Arne Norre Ekstroem and Jan Hvolgaard Mikkelsen
%
% This directory contains the receiver source for the GSMsim receiver.
%
% These are the files in this directory, along with a brief
% introduction of the files. Refer to the individual files or the
% printed documentation for further details.
% 
% make_increment    - For creating precalculatable part of metric
% make_next         - State to legal next-state mapping table
% make_previous     - State to legal previous-state mapping table
% make_start        - For finding start state of viterbi algorithm
% make_stops        - For finding stop states of viterbi algorithm
% make_symbols      - State number to symbol mapping table
% mafi              - For synchronization matched filtering channel 
% 		      estimation and down conversion (Renamed from mf)
% viterbi_detector  - The viterbi algorithm
% viterbi_init      - Setup of tables
% DeMUX             - Does demultiplexing of GSM burst
% deinterleave      - GSM frame to burst deinterleaver.
% channel_dec       - Channel decoder for deinterleaved GSM frame.
%
% $Id: Contents.m,v 1.5 1998/10/01 15:26:34 aneks Exp $

% $Log: Contents.m,v $
% Revision 1.5  1998/10/01 15:26:34  aneks
% Corrected mf to mafi
%
% Revision 1.4  1998/06/24 13:22:24  aneks
% Inserted descriptions of remaining functions.
%
% Revision 1.3  1997/08/27 10:53:13  aneks
% Inserted description of DeMUX
%
% Revision 1.2  1997/07/30 16:42:52  aneks
% Inserted RCS things
%