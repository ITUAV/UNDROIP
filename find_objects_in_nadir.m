function [nadir_edge, nadir_objects]=  find_objects_in_nadir(nadir_edge, varargin)

% This function finds objects in the water column and correct the nadir
% edge 

% Input-
% nadir_edge: a vector of values that containing the nadir edge
% 
% Output-
% nadir_edge: nadir_edge with objects removed
% nadir_objects: a vector with the rough locations of the objects
%
%
%
% Author: Mohammed Al-Rawi [al-rawi@ut.pt]
% Project: SWARMs
% Date: Jan 12, 2017
%
%
% Project SWARMs http://www.swarms.eu/
%
%
% License:
%=====================================================================
% This is part of the UNDROIP toolbox, released under
% the GPL. https://github.com/rawi707/UNDROIP/blob/master/LICENSE
% 
% The UNDROIP toolbox is available free and
% unsupported to those who might find it useful. We do not
% take any responsibility whatsoever for any problems that
% you have related to the use of the UNDROIP toolbox.
%
% ======================================================================

%%

defaults.object_thresh_signal= 6; % lower values means a signal cahnge below this threshold will be identified as object
defaults.median_filter_parameter = 20; % higher values are intended remove high spikes in the signal
args = propval(varargin,defaults);

new_nadir = medfilt1(nadir_edge, args.median_filter_parameter);
diff = abs( new_nadir- nadir_edge);
loci = logical(diff> args.object_thresh_signal);
tmp = nadir_edge(1);
nadir_edge(loci) = floor(new_nadir(loci));
nadir_objects = loci;
nadir_edge(1)=tmp;
nadir_objects(1)=0;



    
        