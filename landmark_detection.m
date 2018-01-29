function [landmarks, img] = landmark_detection(img, nadir_edge, varargin)

% figure; plot_side_scan_sonar_data( Lmk_left.landmakrs2D, Lmk_right.landmakrs2D, 'use_log', false); 

defaults.spline_tol = 1e-7; % The lower spline_tol used, the lower fluctuations in the signal will be detected. To detect landmarks you may use a higher value, e.g., 1E-4 
defaults.scale_value = 100; % 100; % used to scale the output image after dividing the singals by the cubic spline weights
defaults.date_of_run = datestr( datetime );  % stores the date and time of the run
defaults.points_to_add = 10;
defaults.E_threshold = 10; % E_threshold width/prominence, higher values may indicate wide but low peaks/shadows

args = propval(varargin,defaults);
img = remove_water_column(img, nadir_edge);
peaks2D = zeros(size(img), 'double'); % A matrix to store the values;
shadows2D = peaks2D; 

[n_pings, no_points] = size(img);


signal = find_across_track_profile(args, nadir_edge, img);
[landmarks.shadows, landmarks.shadows2D]= do_it(n_pings, signal, shadows2D, args.E_threshold, nadir_edge, true);
[landmarks.peaks, landmarks.peaks2D]= do_it(n_pings, signal, peaks2D, args.E_threshold, nadir_edge, false);



function signal = find_across_track_profile(args, nadir_edge, img)
fprintf('finding across track profile(s) \n'); 
[n_pings, no_points] = size(img);
wL_prev = 1; 
for ping_idx = 1:n_pings  % the position to select one sample to perform exponential fitting, this idx was roughly chosen, not sure if there is a better alternative to chose among the indices!
           
    fmat = img(ping_idx, :);
    fmat(logical(fmat==0)) = 1; % replacing 0s values with 1s, since they will cause a problem with the log function
    in_axis = [nadir_edge(ping_idx)- args.points_to_add : no_points];  % neglecting the gap/nadir area    
    wL = spline_fit(fmat(in_axis), in_axis, ping_idx, wL_prev, args.spline_tol);   % fitting   
    wL = wL(args.points_to_add+1:end);  % removing the  added points            
    signal{ping_idx}=wL;   
    progress(ping_idx, n_pings); % showing execution progress           
end


function [landmarks, peaks2D]= do_it(n_pings, all_signal, peaks2D, E_threshold, nadir_edge, shadows)

n_points = size(peaks2D, 2);
fprintf('analyzing peaks/shadows \n');
number_of_peaks_or_shadows =0;
all_E = [];

for ping_idx = 1:n_pings
   % fprintf(' %d', ping_idx);
    if ~shadows
        signal = all_signal{ping_idx};
    else        
        signal = 1.01*max(all_signal{ping_idx}) - all_signal{ping_idx};
    end
        
    [pks, locs, width, prominence] = findpeaks( signal, 'WidthReference', 'halfprom');
    pks=pks(2:end);  % neglecting the first high peak, antenna gain
    locs = locs(2:end) ; % neglecting the first high peak, antenna gain
    width = round(width(2:end));  %  or, multiply by 2
    prominence = prominence(2:end) ; % neglecting the first high peak, antenna gain
    E = 2*width./prominence;
    
    all_E = [all_E E];
    
    idx_E = E<E_threshold;    
    
    if ~isempty(locs) && any( (locs-width) <=0 ) % a false second peak at the gain-peak
        xx = find( (locs-width)<0);
        idx_E(1:xx)=0;
    end
                
    E=E(idx_E);
    pks=pks(idx_E);
    locs=locs(idx_E);
    width=width(idx_E);
    
    i=1;
    nn=length(locs);
    while(i<=nn)        
        w2= floor(width(i)/2);
        idy = nadir_edge(ping_idx)+locs(i)-w2: nadir_edge(ping_idx) + locs(i)+ w2;
        if(idy(end)> n_points) 
            pks(i)=[]; width(i)=[]; locs(i)=[]; nn=nn-1;
        else
        peaks2D(ping_idx, idy) = pks(i); i=i+1;
        end
        
    end
    number_of_peaks_or_shadows = number_of_peaks_or_shadows +length(pks);    
    landmarks.width{ping_idx} = width;
    landmarks.loc{ping_idx}=locs+(~isempty(locs))*nadir_edge(ping_idx);   % ~isempty(locs) is used here to exclude the addition when loc is empty
    landmarks.significane{ping_idx}=E;        
    progress(ping_idx, n_pings); % showing execution progress 
end

landmarks.number_of_peaks_or_shadows = number_of_peaks_or_shadows;
landmarks.all_E=all_E;


% drawing the peaks with: findpeaks(signal,'WidthReference', 'halfprom', 'Annotate','extents')


% for ping_idx = 1:n_pings
%     signal = poly_values(ping_idx,:);
%     [pks, locs, width, prominence] = findpeaks( signal, 'WidthReference', 'halfprom');
%     pks=pks(2:end);  % neglecting the first high peak, antenna gain
%     locs = locs(2:end) ; % neglecting the first high peak, antenna gain
%     width = width(2:end); 
%     for i=1: length(locs)
%         w2= floor(width(i)/2);
%         peaks2D(ping_idx, locs(i)-w2: locs(i)+ w2) = pks(i);
%     end
%     
%     landmarks.peaks{ping_idx} = pks;
%     landmarks.pks_loc{ping_idx}=locs;   
%     landmarks.significane{ping_idx}=width./prominence;    
%     
%     DataInv = 1.01*max(signal) - signal; % inverting the signal to find the shadows
%     % DataInv(1:locs(1))=0;
%     [~, locs] = findpeaks(DataInv);
%     mins = signal(locs);
%     mins=mins(2:end); 
%     locs = locs(2:end); % neglecting the first high peak, antenna gain
%     shadows2D(ping_idx,locs) = mins;
%     landmarks.shadaows{ping_idx}=mins;
%     landmarks.shadow_loc{ping_idx}=locs;
%     
%     
%     landmarks.signal{ping_idx}=signal;   
%     
% end
% landmarks.landmakrs2D=peaks2D;
% landmarks.shadows2D=shadows2D;



% for ping_idx = 1:n_pings
%     signal = poly_values(ping_idx,:);
%     [pks, locs] = findpeaks( signal);
%     pks=pks(2:end); 
%     locs = locs(2:end) ; % neglecting the first high peak, antenna gain
%     peaks2D(ping_idx, locs) = pks;
%     landmarks.peaks{ping_idx} = pks;
%     landmarks.pks_loc{ping_idx}=locs;   
%     
%     DataInv = 1.01*max(signal) - signal;
%     % DataInv(1:locs(1))=0;
%     [~, locs] = findpeaks(DataInv);
%     mins = signal(locs);
%     mins=mins(2:end); 
%     locs = locs(2:end); % neglecting the first high peak, antenna gain
%     shadows2D(ping_idx,locs) = mins;
%     landmarks.shadaows{ping_idx}=mins;
%     landmarks.shadow_loc{ping_idx}=locs;
%     landmarks.signal{ping_idx}=signal;
%     progress(ping_idx, n_pings); % showing execution progress 
% end
% 
% landmarks.landmakrs2D=peaks2D;
% landmarks.shadows2D=shadows2D;
% 
% 
% 

