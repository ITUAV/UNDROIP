function sss_in = fast_enhance_sss_image(sss_in, varargin)
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
defaults.spline_tol = 1e-8; % The lower spline_tol used, the lower fluctuations in the signal will be detected. To detect landmarks you may use a higher value 
defaults.scale_value = 100; % 100; % used to scale the output image after dividing the singals by the cubic spline weights
defaults.date_of_run = datestr( datetime );  % stores the date and time of the run
defaults.n_selected_pings = 9; % pings used to estimate the weights
defaults.exp_curve_start=100; % The position to start exponential fitting after the peak of the across-track signal
args = propval(varargin,defaults);

tic;
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
[nadir.edge] = detect_first_echo_v2( img ); % nadir = find_nadir_edge(img, parameters.nadir); is another function based on spline fitting but slower, do not know which one is more accurate 

% detect and remove objects in the water column
[nadir.edge, nadir.objects]=  find_objects_in_nadir(nadir.edge); % updates the nadir edge after removing possible objects in the water column

[n_pings, no_points] = size(img);
poly_values = zeros(size(img), 'double'); % A matrix to store the weights
wL_prev = 1; % to be used in sanity check

% Fast estimation of the normalization weights

selected_pings = randperm(n_pings, parameters.n_selected_pings);

% nadir_min_start = min( nadir.edge(selected_pings));

i=1;

for ping_idx = (selected_pings)  % the position to select one sample to perform exponential fitting, this idx was roughly chosen, not sure if there is a better alternative to chose among the indices!
    
    % Firs, performaing spline fitting to the whole across track ping,
    % starging from the first return
    fmat = double( img(ping_idx, :) );    
    fmat(logical(fmat==0)) = 1; % replacing 0s values with 1s, since they will cause a problem with the log function
    in_axis = [nadir.edge(ping_idx)-parameters.points_to_add : no_points];  % neglecting the gap/nadir area   
    wL = spline_fit(fmat(in_axis), in_axis, ping_idx, wL_prev, parameters.spline_tol);   % fitting    
    wL = wL(parameters.points_to_add+1:end);  % removing the  added points 
    
    % Now, performing expnential fitting on the curve after the peak
    in_axis = [nadir.edge(ping_idx) : no_points];  % neglecting the gap/nadir area   
    [mm id] = max(wL(1:floor(length(wL)/2))); % due to noise, sometimes there are other peaks
    x1 = id + parameters.exp_curve_start: length(wL); % starting right after the peak by 
    y1 = wL(id + parameters.exp_curve_start:end); 
    f = fit(x1(:), y1(:) ,'exp2');         
    new_in_axis = length(y1)-100:length(y1); % The tail segment, hopefully it is lienar wiht slope close to 0
    x2 = x1(new_in_axis);
    y2 = feval(f, x1(new_in_axis))';
    [p, S, mu] = polyfit(x2, y2, 1); % testing linearity of the curve right tail
   
    subplot(3,3,i); plot( fmat(in_axis)); hold on; plot(wL);  hold on; 
    plot(f, x1, y1); title([' ping idx= ' num2str(ping_idx) ', i= ' num2str(i) ', slope= ' num2str(p(1))]);
    
    i=i+1;
    
end

xx= 0;
for i=1:9
  %   xx= xx+ sp{i}.wL
   plot(sp{i}.wL)
   hold on;
end
xx=xx/9;
hold on; plot(xx);

    [p,S] = polyfit(in_axis,sp{9}.wL,3)

f = fit(in_axis(600:end),sp{9}.wL(600:end),'exp1')


% Now, use spline fitting and do the normalization
for ping_idx = 1:n_pings  % the position to select one sample to perform exponential fitting, this idx was roughly chosen, not sure if there is a better alternative to chose among the indices!
       
    fmat = double( img(ping_idx, :) );    
    fmat(logical(fmat==0)) = 1; % replacing 0s values with 1s, since they will cause a problem with the log function
    in_axis = [nadir.edge(ping_idx)-parameters.points_to_add : no_points];  % neglecting the gap/nadir area    
    wL = spline_fit(fmat(in_axis), in_axis, ping_idx, wL_prev, parameters.spline_tol);   % fitting   
    wL = wL(parameters.points_to_add+1:end);  % removing the  added points 
    if sum(imag(wL)) 
        break;
    end
    
    in_axis = (nadir.edge(ping_idx): no_points);  % getting the original axis witout the added points    
    img(ping_idx, in_axis) = parameters.scale_value*( fmat(in_axis)./wL); % normalizing the ping     
    img(ping_idx, 1:nadir.edge(ping_idx)-1)= 1; % setting the gap to 1 (not to zero) useful in log display    
    poly_values(ping_idx, in_axis) = wL;
    wL_prev=wL;   % this is necessary for sanity check
    progress(ping_idx, n_pings); % showing execution progress   
        
end

img = double(uint32(img)); % converting the image ...not sure if we need this

end


function wL= spline_fit(fmat, in_axis, ping_idx, wL_prev, spline_tol)
    fmat = log(fmat);       
    wL = csaps(in_axis, double(fmat), spline_tol ,  in_axis); % plot(ys); hold on; plot(fmat)    
    wL = check_sanity(wL, ping_idx, wL_prev);
    wL= exp(wL); %  2.^wL;  % probably, -ve values may appear at the ver far end, convering them to +ve poses no problem         
end


function wL = check_sanity(wL, ping_idx, wL_prev)
if(min(wL)<0)    
    fprintf('ping id %d', ping_idx);
    fprintf('--------------------------------------------------- Overfitting problem -------------------------------------------------------------\n');
    fprintf('--------------   negative values due to over fitting, \n  -------------------\n');
    fprintf('-------------- the absolute value is always used, you have to check the results, \n  you may change (increase/decrease) the polynomial degree and try again if not satisfied with them     -------------------');   
    wL= abs(wL);
    return;
end

 if any(isnan(wL)); 
     fprintf('Due to matrix factorization singularities, Nan values appeared at %d, we shall use a previously fitted polynomial \n ', ping_idx); 
     xx = length(wL)-length(wL_prev);
     if xx>0
         wL_prev(end+1:end+xx)=wL_prev(end);
     elseif xx<0
         wL_prev(end+xx+1:end)=[];
     end    
         
     wL = log(wL_prev);
     return;     
 end
 % wL=wL; wL is OK

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






