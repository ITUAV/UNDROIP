function sss_in = enhance_sss_image(sss_in, varargin)
%  Performs image enhancement to side scan sonar images
%  The method is based on dividing the sonar image values by the weights
%  obtained from cubic spline (or polynomial) fitting of each across-track sample
%
% Input - 
%  sss_in: a structure containing x.left and x.right, e.g., left and righ scan
%  images respectively
%
% Output-
% the same input image structure after adding the enhanced image to it
% (the same structure is used to save space)
%
% Example:
% out_img = enhance_sss_image(sss_in); 
% in_img will be updated with the normalized values, but the originals will stay intact
% All the enhanced images will be appended to the input structure 'x'
%
%
% x = enhance_sss_image(eca_data)
% Author: Mohammed Al-Rawi [al-rawi@ut.pt]
% Project: SWARMs
% Date: Sept 12, 2016
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


defaults.points_to_add = 10; % For a better fitting, adding points to the data just before the nadir/gap area
defaults.spline_tol = 1e-8; % The lower spline_tol used, the lower fluctuations in the signal will be detected. To detect landmarks you may use a higher value, e.g., 1E-4 
defaults.scale_value = 100; % 100; % used to scale the output image after dividing the singals by the cubic spline weights
defaults.date_of_run = datestr( datetime );  % stores the date and time of the run

args = propval(varargin,defaults);


% nadir_edge = get_measured_nadir(sss_in.posXY, sss_in.res);

% Data processing
tic;
disp('processing left scan...');
[sss_in.left_norm, args.nadir.left, sss_in.left_poly_values] = intensity_normalization(sss_in.left, args);
fprintf('\n processing right scan... \n');
[sss_in.right_norm, args.nadir.right, sss_in.right_poly_values] = intensity_normalization(sss_in.right, args);
fprintf('\n Time needed to enhance the image is %.2f second(s) \n', toc);
sss_in= store_values(sss_in, args);
end


function [img, nadir, poly_values]= intensity_normalization(img, parameters)

% First, detecting the start of each across-track sample, nadir edge
[nadir.edge] = find_nadir_edge_v2( img ); % nadir.edge = find_nadir_edge(img, parameters.nadir); is another function based on spline fitting but slower, do not know which one is more accurate 


% detect and remove objects in the water column
[nadir.edge, nadir.objects]=  find_objects_in_nadir(nadir.edge); % updates the nadir edge after removing possible objects in the water column

% %%%%%% temporary test
% img = b_mu_correction(img);
% %%%%% end of temporary test

[n_pings, no_points] = size(img);
poly_values = zeros(size(img), 'double'); % A matrix to store the weights
wL_prev = 1; % to be used in sanity check

% Now, use spline fitting and do the normalization

pk_cntr=zeros(n_pings, 1); mm=pk_cntr;
for ping_idx = 1:n_pings  % the position to select one sample to perform exponential fitting, this idx was roughly chosen, not sure if there is a better alternative to chose among the indices!
     
    fmat = double( img(ping_idx, :) );    
    fmat(logical(fmat==0)) = 1; % replacing 0s values with 1s, since they will cause a problem with the log function
    in_axis = [nadir.edge(ping_idx)-parameters.points_to_add : no_points];  % neglecting the gap/nadir area    
    wL = spline_fit(fmat(in_axis), in_axis, ping_idx, wL_prev, parameters.spline_tol);   % fitting   
    wL = wL(parameters.points_to_add+1:end);  % removing the  added points 
    [mm(ping_idx), pk_cntr(ping_idx)] = max(wL(1:700)); 
%     if sum(imag(wL)) %????? 
%         break;
%     end
    
    in_axis = (nadir.edge(ping_idx): no_points);  % getting the original axis witout the added points    
    img(ping_idx, in_axis) = parameters.scale_value*( fmat(in_axis)./wL); % normalizing the ping     
    img(ping_idx, 1:nadir.edge(ping_idx)-1)= 1; % setting the gap to 1 (not to zero) useful in log display    
    poly_values(ping_idx, in_axis) = wL;
    wL_prev=wL;   % this is necessary for sanity check
   
    progress(ping_idx, n_pings); % showing execution progress   
        
end


img = double(uint32(img)); % converting the image ...not sure if we need this

end







 


function x= store_values(x, parameters)
x.parameters=parameters;
x.processing{1} = 'Backscatter and echo decay normalization, left_norm contains the normalized signal';
% x.function0 = 'functions that can be used on the data';
% x.function1 = 'out_img = norm255(in_img) % normalize the image to [0, 255]'; % normalize the image to [0, 255]
% x.function2 = '[low, hi]= isolate_spikes(img) %[decomoses the image into the normal (low) and spikes (hi), using histogram analysis]'; 
% x.function3 = '[out_img] = slant_2_ground(in_img, first_return ) % generates a ground-range image, first return is stored parameters.left_nadir.edge or right'; 
% x.function4 = 'plot_side_scan_sonar_data( left_img, right_img, res )';
end






