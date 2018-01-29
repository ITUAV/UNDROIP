function hitsogram_water_col(img, edge)

% this function finds the histogram in the water column for the region
% bounded by botto_ix1-edge to bottom_ix2-edge, edge is the first return;
% bottome_ix1>bottom_ix2; always

bottom_ix1= 10;
noise_threshold = 150; % this threshold will be used to infer if other signals, and not only noise have been included in the water column
bottom_ix2= 5; 


[n_pings, no_points] = size(img);

water_col_noise = zeros(n_pings, bottom_ix1-bottom_ix2+1);


for ping_idx = 1:n_pings 
    water_col_noise(ping_idx,:) = img(ping_idx, edge-bottom_ix1: edge-bottom_ix2);
end

if  max(max(water_col_noise))>noise_threshold
    error('signals have been included, and not only noise, please reduce the value of hist_size');    
end

sss_histogram(water_col_noise);

