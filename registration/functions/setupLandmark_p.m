function [imgS_p,pos_landmk_p]=setupLandmark_p(imgS)

%
% giving the good syntax for data for portside
%
% I. Leblond
%
% ECA Robotics march 2017
%

Ls_p=bwlabel(imgS);

statsS_p=regionprops(Ls_p,'BoundingBox');

sizeS_p=struct2cell(statsS_p);
sizeS_p=cell2mat(sizeS_p);
sizeS_p=reshape(sizeS_p,4,length(sizeS_p)/4); 
sizeS_p=sizeS_p'; 


imgS_p=zeros(size(imgS)); %initialisation of landmarks image and landmark position 
pos_landmk_p=[];

i_landmk_poss=min(size(imgS,1),ceil(sizeS_p(:,2)+1/2.*sizeS_p(:,4))); % position of landmarks = middle of pings
j_landmk_poss=ceil(sizeS_p(:,1))+sizeS_p(:,3)-1; % across track, end of bounding box for portside

% position of landmarks

for ii=1:size(sizeS_p,1)
    
        
        ind=find(Ls_p==ii);
        
        imgS_p(ind)=1;
        
        
        pos_landmk_p=[pos_landmk_p; i_landmk_poss(ii) j_landmk_poss(ii) sizeS_p(ii,4)]; 
        
    
end