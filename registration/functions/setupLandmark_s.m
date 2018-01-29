
function [imgS_s_fin,pos_amer_s]=setupLandmark_s(imgS)

%
% giving the good syntax for data for starboard
%
% I. Leblond
%
% ECA Robotics march 2017
%

Ls_s=bwlabel(imgS);

statsS_s=regionprops(Ls_s,'BoundingBox');

sizeS_s=struct2cell(statsS_s); % extraction of size of bounding boxes
sizeS_s=cell2mat(sizeS_s);
sizeS_s=reshape(sizeS_s,4,length(sizeS_s)/4);
sizeS_s=sizeS_s';

imgS_s_fin=zeros(size(imgS)); %initialisation of landmarks image
pos_amer_s=[];

i_landmk_poss=min(size(imgS,1),ceil(sizeS_s(:,2)+1/2.*sizeS_s(:,4))); % position landmark = middle ping of the bounding box
j_landmk_poss=ceil(sizeS_s(:,1)); % for starboard, beginning of the bounding box


% position of landmarks

for ii=1:size(sizeS_s,1)
    
    
    ind=find(Ls_s==ii);
    
    imgS_s_fin(ind)=1;
    
    
    pos_amer_s=[pos_amer_s; i_landmk_poss(ii) j_landmk_poss(ii) sizeS_s(ii,4)];
    
    
    
end



