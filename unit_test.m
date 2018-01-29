function sss_data = unit_test (fname, dir_in, varargin)
% Testing a few functions
% Although you can, you do not need to run this code from the command line, 
% This is just an example of how some functions are implemented
%
% Author: Mohammed Al-Rawi [al-rawi@ut.pt]
% Project: SWARMs
% Date: Jan 18, 2017
%
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

% % Example 1: Reading XTF without bathy image
% defaults.dir_in = 'C:\Users\Mohammed\Desktop\Swarms project\Sonar data and viewer\ECA data\'; % name of the directory that contains the images, change it to your directory
% defaults.fname = '20150706_081412_081412_L005.xtf';  % name of the XTF file you want to read
% args = propval(varargin,defaults);
% [sss_data] = read_xtf_sonar_bath_eca(args.fname, args.dir_in, 'store_ping', false, 'has_bathy_image', false);




% Example 2: Reading XTF with bathy image
% defaults.dir_in = 'C:\Users\Mohammed\Desktop\Swarms project\Sonar data and viewer\ECA data\Canaria Trials Sept 2016\M2'; % name of the directory that contains the images, change it to your directory
% defaults.fname ='M2_L009.xtf';  % name of the XTF file you want to read

defaults.dir_in = 'C:\Users\Mohammed\Desktop\Swarms project\Sonar data and viewer\NTNU data'; % name of the directory that contains the images, change it to your directory
defaults.fname ='135919_sss_refvraket.xtf';  % name of the XTF file you want to read

  
%  
%  defaults.dir_in = 'C:\Users\Mohammed\Desktop\Swarms project\Sonar data and viewer\ECA data\Canaria Trials Sept 2016\M3'; % name of the directory that contains the images, change it to your directory
%  defaults.fname ='M3_L006.xtf';  % name of the XTF file you want to read
%  
args = propval(varargin,defaults);


[sss_data] = read_xtf_sonar_bath_eca(args.fname, args.dir_in, 'store_ping', false, 'has_bathy_image', false);
% [sss_data] = read_xtf_sonar_eca([args.dir_in '\' args.fname]);
 readXTFFiles([args.dir_in '\' args.fname]);
% perforing intensity normalization
%  sss_data = fast_enhance_sss_image(sss_data);
%sss_data.left = b_mu_correction(sss_data.left);
% sss_data.right = b_mu_correction(sss_data.right);


% sss_data = enhance_sss_image(sss_data);
sss_data = enhance_sss_image(sss_data, 'spline_tol', 1E-8);

sss_data.nadir_edge = get_measured_nadir(sss_data.posXY, 0.012);

% Denoising using sgolayfilt filter: https://www.mathworks.com/help/signal/ref/sgolayfilt.html
sss_data.left_norm_filt = denoise_sss_image(sss_data.left_norm, sss_data.parameters.nadir.left);
sss_data.right_norm_filt = denoise_sss_image(sss_data.right_norm, sss_data.parameters.nadir.right);

% applying a high pass filter
sss_data.left_norm_filt = sss_high_pass_filter(sss_data.left_norm_filt);
sss_data.right_norm_filt = sss_high_pass_filter(sss_data.right_norm_filt);

% decompose the normalized image to low and high values
[sss_data.left_norm_low, sss_data.left_norm_hi] = isolate_spikes(sss_data.left_norm);
[sss_data.right_norm_low, sss_data.right_norm_hi] = isolate_spikes(sss_data.right_norm);


% performing slant to ground range correction
[sss_data.left_ground] = slant_2_ground(sss_data.left_norm, sss_data.parameters.nadir.left.edge );
[sss_data.right_ground] = slant_2_ground(sss_data.right_norm, sss_data.parameters.nadir.right.edge );


% speed correction, I am using the original data here
[sss_data.left_norm_spd, sss_data.right_norm_spd, sss_data.new_spd_res] = speed_correct_eca(sss_data.left_norm, sss_data.right_norm, sss_data.posXY, sss_data.res, 'target_res', 0.05);


% Now, displaying some images
figure;  plot_side_scan_sonar_data( 10*sss_data.left, 10*sss_data.right, 'use_log', true); title('original image in log(x)');  % display original with log

figure; plot_side_scan_sonar_data( (sss_data.left)/2, (sss_data.right)/2, 'use_log', false); title('original image directly, by squeezing higher values to 255'); % display original directly, by squeezing higher values to 255

figure; plot_side_scan_sonar_data( sss_data.left_norm, sss_data.right_norm, 'use_log', false); title('intensity normalized image');  % display intensity normalized image

figure; plot_side_scan_sonar_data( sss_data.left_norm_filt, sss_data.right_norm_filt, 'use_log', false); title('intensity normalized and filterd image');   % display intensity normalized and filterd image

figure; plot_side_scan_sonar_data( sss_data.left_ground, sss_data.right_ground, 'use_log', false); title('intensity normalized ground range');  % display intensity normalized ground range image

figure; plot_side_scan_sonar_data( sss_data.left_norm_spd, sss_data.right_norm_spd, 'use_log', false); title('intensity normalized with speed correction'); % display original with log

figure; plot_side_scan_sonar_data( sss_data.right_norm, sss_data.right_norm_hi, 'do_flip', false ); title('landmarks'); % display detected landmarks

figure; draw_nadir(sss_data.left, sss_data.right, sss_data.parameters.nadir, 'res', sss_data.res);  title('projecting first returns on the original image'); 

 
figure; plot_side_scan_sonar_data( b_mu_correction(sss_data.left), b_mu_correction(sss_data.right), 'use_log', false);

nadir_edge = get_measured_nadir(sss_data.posXY, 0.012);
figure; plot_side_scan_sonar_data( 2*reduce_img_range(remove_water_column(sss_data.left, nadir_edge)), 2*reduce_img_range(remove_water_column(sss_data.right, nadir_edge)), 'use_log', false); 


result = energy_along_track_measure(sss_data.left, sss_data.right, sss_data.parameters.nadir);
result2 = energy_along_track_measure(sss_data.left_norm, sss_data.right_norm, sss_data.parameters.nadir);
subplot(2,2,1), plot(result.en_var_L); title('left, along-track, ping engergy');  subplot(2,2,2), plot(result.en_var_R); title('right, along-track, ping energy')
subplot(2,2,3), plot(result2.en_var_L); title('left, enhanced along-track, ping engergy');  subplot(2,2,4), plot(result2.en_var_R); title('right, enhanced along-track, ping energy')


% figure; plot(result.en_var_L./result.en_mean_L); hold on; plot(result2.en_var_L./result2.en_mean_L); hold on; plot(result_lg.en_var_L./result_lg.en_mean_L);

figure;
subplot(2,2,1), plot(result.en_mean_L); title('left, along-track, ping engergy');  subplot(2,2,2), plot(result.en_mean_R); title('right, along-track, ping energy')
subplot(2,2,3), plot(result2.en_mean_L); title('left, enhanced along-track, ping engergy');  subplot(2,2,4), plot(result2.en_mean_R); title('right, enhanced along-track, ping energy')

plot(result.en_var_L); hold on; plot(result2.en_var_L);

hold on; plot(result_lg.en_var_R./result_lg.en_mean_R);


% removing the water column from the original image
sss_data.left  =  remove_water_column(sss_data.left, sss_data.parameters.nadir.left.edge);
sss_data.right =  remove_water_column(sss_data.right, sss_data.parameters.nadir.right.edge);

% if we have the bathymetry data
figure; plot_side_scan_sonar_data(30*sss_data.image_bathy_port, 30*sss_data.image_bathy_stbd , 'use_log', false); title('image bathy port                                    image bathy stdb');
idx=1899;
figure; plot((sss_data.image_bathy_port(idx,:))); title(['bathy port  index ' num2str( idx)] );
figure; plot((sss_data.image_bathy_stbd(idx,:))); title(['bathy stdb index ' num2str(idx)]);




