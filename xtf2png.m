function xtf2png(fname, path_)
% A function to convert the sss image stored in xtf format to png image
%
% Input-
% fname: the name of the xtf file
% dir: the directory whre the xtf is located
%
% Example: fname = 'M2_L009';
%  path_ =  'C:\Users\Mohammed\Desktop\Swarms project\Sonar data and viewer\ECA data\Canaria Trials Sept 2016\M2\';
% Author: Mohammed Al-Rawi [al-rawi@ut.pt]
% Project: SWARMs
% Date: Sept 12, 2016

%
%
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

% Todo: needs to be refined further
       
    [eca_data] = read_xtf_sonar_eca([path_ fname '.xtf']);
    imwrite(uint8(log(eca_data.WF+1)*10), [path_ fname '.png']);

%  end




