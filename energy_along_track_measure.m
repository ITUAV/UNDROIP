function result = energy_along_track_measure(left_image, right_image, nadir)
% This function estimates the overall variation in energy signal per each
% ping.
%
% Input
% sss_in: a structure that contains the left and right (original) SSS image, the
% normalized scans and the nadir edge 
%
%
% Author: Mohammed Al-Rawi [al-rawi@ut.pt]
% Project: SWARMs
% Date: Sept 12, 2016
%
% 
%
%
%
% Project SWARMs http://www.swarms.eu/
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




[result.en_var_L, result.en_mean_L] = do_it(left_image, nadir.left.edge);
[result.en_var_R, result.en_mean_R] = do_it(right_image, nadir.right.edge);

end


function [s, m] = do_it(img, nadir_edge)

[npings, npts]=size(img);

% s = zeros(npts,1);
% m = zeros(npts,1);
% 
% 
% for idx= nadir_edge(1): npts    
%     m(idx)= mean(img(:,idx));
%     s(idx) = std(img(:,idx))/( m(idx) + 0.001);  % the 0.001 has been added to prevent overflow if the signal is all zeros
% end

s = zeros(npings,1);
m = zeros(npings,1);

% for idx= nadir_edge(1): npings    
%     m(idx)= mean(img(idx, :));
%     s(idx) = std(img(idx, :))/( m(idx) + 0.001);  % the 0.001 has been added to prevent overflow if the signal is all zeros
% end

% using log
for idx= nadir_edge(1): npings    
    m(idx)= mean(log(img(idx, :)));
    s(idx) = std(log(img(idx, :)))/( m(idx) + 0.001);  % the 0.001 has been added to prevent overflow if the signal is all zeros
end


% s= s/(npings*npts);
 
end
 
 
