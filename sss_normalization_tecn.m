function [normalized_image_left, normalized_image_right] = sss_normalization_tecn(sonar_data_left, sonar_data_right)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % TCNL SSS normalization algorithm - Read SSS file, transform it into image and normalize it
  % Input:    - sonar_data_left: sonar raw data matrix (left side)
  %           - sonar_data_right: sonar raw data matrix (right side)
  %
  % Output:   normalized_image_left: Normalized image data (left side)
  %           normalized_image_right: Normalized image data (right side)
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  normalized_image = [];
  normalized_image_left = [];
  normalized_image_right = [];
  sss_data = [];
  isRightData = 0;
  isLeftData = 0;

  % Check number of inputs.
  if nargin ~= 2
      print_usage();
      error('myfuns:somefun2:TooManyInputs', 'Error reading input parameters'); 
  end

  
  % Check input data matrix
  if size(sonar_data_left) == 0 && size(sonar_data_right) ~= 0
    sss_data = sonar_data_right;
    isRightData = 1;
  elseif size(sonar_data_left) ~= 0 && size(sonar_data_right) == 0
    sss_data = fliplr(sonar_data_left);
    isLeftData = 1;
  elseif size(sonar_data_left) ~= 0 && size(sonar_data_right) ~= 0
    sss_data = merge_sss_sides(fliplr(sonar_data_left), sonar_data_right);
    isRightData = 1;
    isLeftData = 1;
  else
    disp("Both data matrix are empty");
    return;
  end
  
  
  % Image range normalization
  img_sss_data = sss_data2img(sss_data);
  
  
  % Normalize image
  disp("starting image normalization");
  normalized_image = sonar_correction_tcnl(sss_data);
  %disp("saving normalized image");
  %imwrite(mat2gray(normalized_image), normalized_image_path);

  
  % Output reconstruction
  if isRightData == 0 && isLeftData ~= 0
    normalized_image_left = normalized_image;
    normalized_image_right = [];
  elseif isRightData ~= 0 && isLeftData == 0
    normalized_image_left = [];
    normalized_image_right = normalized_image;
  else
    [row_left, col_left] = size(sonar_data_left);    
    normalized_image_left  = normalized_image(:, 1:col_left);
    normalized_image_right = normalized_image(:, col_left+1:end);  
  end

  disp('function finished');

endfunction



function print_usage()
  disp('');
  disp('----------------------------------------------------------------------------------------');
  disp('       USAGE:');
  disp("[norma_image] = sss_normalization_tecn('imput_data.xtf', 'eca', 0, 'normalized_sss.png')");
  disp('----------------------------------------------------------------------------------------');
  disp('');
endfunction


function [merged_data] = merge_sss_sides(sss_left, sss_right)
  
  merged_data = [];
  
  %Check array size
  [row_l,col_l] = size(sss_left);
  [row_r,col_r] = size(sss_right);
  
   
  if row_l == row_r  
    merged_data = horzcat(sss_left, sss_right);
  else
    min_row = min(row_l, row_r);
    merged_data = horzcat(sss_left(0:min_row, :), sss_right(0:min_row, :));
  end
  
endfunction


function [image_data] = sss_data2img(data)
  % IN:   data: raw sonar data
  % OUT:  image_data: input data in image format
  
  img_max_value = max(max(data));
  img_min_value = min(min(data));

  image_data = (data-img_min_value)./(img_max_value-img_min_value).*255;

endfunction


function [norm_image] = sonar_correction_tcnl(image_data)
  block_r = 200; % Block height
  block_c = 200; % Block width
  thr = 1;

  img = image_data(:,:,1);

  % ------------------------------------------------------
  %   check image widt/height relationship
  % ------------------------------------------------------
  [sz_r ,sz_c] = size(img);
  reshape = false;
  if sz_r<sz_c
      img = imresize(img, [sz_c, sz_r]);
      old_sz_r = sz_r;
      old_sz_c = sz_c;
      sz_r = sz_c;
      sz_c = old_sz_r;
      reshape = true;
  end
    
  % ------------------------------------------------------
  %               Enhancenment algorithm
  % ------------------------------------------------------
  % Preallocate mean and std_dev matrices
  mean_sub = zeros(floor(sz_r/block_r),floor(sz_c/block_c)); 
  std_sub = zeros(size(mean_sub));
  
  for counter_row = 1 : sz_r/block_r
      for counter_col = 1 : sz_c/block_c
          % Next four lines compute coordinates for defining the patch
          top_left_r = block_r * (counter_row-1) + 1;
          height = block_r * counter_row;
          top_left_c = block_c * (counter_col -1) + 1;
          width = block_c * counter_col;
          temp = img(top_left_r : height , top_left_c : width);
          temp = temp(:);
          
          % Computation of mean and std 
          mean_sub(counter_row, counter_col) = mean(temp); 
          std_sub(counter_row, counter_col) = sqrt(var(temp));
      end
  end

  % Interpolate the mean_dev
  mean_full = imresize(mean_sub,size(img)); 
  % Interpolate the std_dev
  std_full = imresize(std_sub,size(img)); 

  % compute the PC Mahalanobis's distance
  pcm_dist = (img - mean_full)./std_full;        
  % Compute the absolute value of the distance as it should be positive
  pcm_dist = abs(pcm_dist); 

  % global threshold is now a parameter
  pcm_dist(pcm_dist<thr)= 1;  
  pcm_dist(pcm_dist~=1) = 0;


  for counter_row = 1 : sz_r/block_r
      for counter_col = 1 : sz_c/block_c          
          top_left_r = block_r * (counter_row-1) + 1;
          height = block_r * counter_row;
          top_left_c = block_c * (counter_col -1) + 1;
          width = block_c * counter_col;
          temp = img(top_left_r : height , top_left_c : width);
          temp = temp(:);
          % Find the non-zero pixels in the background
          I = find(pcm_dist(top_left_r : height , top_left_c : width)); 
          % Compute the mean and std_dev for the corresponding intensitities
          mean_sub(counter_row, counter_col) = mean(temp(I)); 
          std_sub(counter_row, counter_col) = sqrt(var(temp(I)));
      end
  end
  
  % Interpolate to find the luminosity
  luminosity = imresize(mean_sub,size(img)); 
  % Interpolate to find the contrast
  contrast = imresize(std_sub,size(img)); 
  % Compute the corrected image
  corrected = (img - luminosity)./contrast; 
  
  
  % ------------------------------------------------------
  %      scalling image values
  % ------------------------------------------------------
  amin = min(corrected(:));
  amax = max(corrected(:));

  adjusted = mat2gray(corrected, [amin, amax]);

  % ------------------------------------------------------
  %     reshape image to original dimensions if needed
  % ------------------------------------------------------
  if reshape == true
      adjusted =  imresize(adjusted, [old_sz_r, old_sz_c]);
  end

  % Set image output
  norm_image = adjusted;

endfunction