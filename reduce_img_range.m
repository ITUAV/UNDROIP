function out_img = reduce_img_range(img)
% ECA's Klein 3500 sonar images have mostly values of multipe 16
% This function, thus, reduces the range by dividing all values by 16

out_img = img;
[s1, s2]=size(img);
img = img/16;
loc = (find((img-floor(img))));
fprintf('Percentage of non-multiple 16 pixels is %d \n', length(loc)/(s1*s2));
v16_1 =(img(loc)*16-1)/16;
loc2= find(v16_1-floor(v16_1));

if isempty(loc2)
    fprintf('Reducing the range by dividing by 16, non-multiple 16 are (pixel_value+1)/16 \n');
    out_img=floor(img); % just rmove the .0625 from all pixesl 
else
    fprintf('contains non-multiple 16 values');
end

    

