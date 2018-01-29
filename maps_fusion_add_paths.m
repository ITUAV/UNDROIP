function [] = maps_fusion_add_paths()

% Adds the paths necessary to use the Toolbox. Assumes
% that you've already got this script in your path, and so
% it uses the location of this script to determine the root
% directory of the rest of the scripts. That way, it
% doesn't need an argument.
%
% Usage: maps_fusion_add_paths


% find the root path

rootdir = fileparts( which('maps_fusion_add_paths'));

% fprintf('Adding paths (root: ''%s'')...\n', rootdir);

% Add core paths.
myaddpath('core');
myaddpath('core/io');
myaddpath('core/preproc');
myaddpath('core/map');
myaddpath('core/util');
myaddpath('core/vis');
myaddpath('core/template');
myaddpath('tutorial');

% nested wrapper for adding relative paths
function myaddpath(p)
  addpath([rootdir '\' p]);
end

end
