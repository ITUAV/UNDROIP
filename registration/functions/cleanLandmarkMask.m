function [pos_ldk_2,imgS2]=cleanLandmarkMask(mask,imgS,pos_ldk)

% removing landmarks in water column or end of range
%
% I. Leblond
%
%, ECA Robotics march 2017
%

imgS2=zeros(size(imgS));

LS=bwlabel(imgS);


pos_ldk_2=[];


for ii=1:size(pos_ldk,1)
    
    if mask(pos_ldk(ii,1),pos_ldk(ii,2))==1
        
        ind=find(LS==ii);
        
        imgS2(ind)=1;
        
        pos_ldk_2=[pos_ldk_2; pos_ldk(ii,:)];
        
    end
        
end
